package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"runtime"
	"strings"
	"time"

	"github.com/teamgram/marmota/pkg/stores/sqlx"
	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/zrpc"
	dfsclient "pwm-server/app/service/dfs/client"
	idgenclient "pwm-server/app/service/idgen/client"
	"pwm-server/app/service/idgen/idgen"
	mediaclient "pwm-server/app/service/media/client"
	"pwm-server/app/tool/stickerimport/internal/catalog"
	"pwm-server/app/tool/stickerimport/internal/importer"
	"pwm-server/app/tool/stickerimport/internal/native"
	"pwm-server/app/tool/stickerimport/internal/pwm"
)

type options struct {
	Source      string
	Config      string
	DryRun      bool
	Resume      bool
	Verify      bool
	Workers     int
	SetID       string
	Offset      int
	Limit       int
	CatalogOnly bool
	ReadyCheck  bool
}

type dryRunResult struct {
	Source       string     `json:"source"`
	Version      string     `json:"version"`
	Checksum     string     `json:"checksum"`
	Config       string     `json:"config"`
	Resume       bool       `json:"resume"`
	Verify       bool       `json:"verify"`
	Workers      int        `json:"workers"`
	SetID        string     `json:"set_id,omitempty"`
	Offset       int        `json:"offset,omitempty"`
	Limit        int        `json:"limit,omitempty"`
	SelectedSets int        `json:"selected_sets"`
	Report       pwm.Report `json:"report"`
}

type config struct {
	OwnerID       int64
	PartSize      int
	VerifyTimeout string
	Mysql         sqlx.Config
	DfsClient     zrpc.RpcClientConf
	MediaClient   zrpc.RpcClientConf
	IdgenClient   zrpc.RpcClientConf
}

type importResult struct {
	Source      string          `json:"source"`
	Version     string          `json:"version"`
	Fingerprint string          `json:"fingerprint"`
	Report      importer.Report `json:"report"`
}

func main() {
	if err := run(os.Args[1:], os.Stdout, os.Stderr); err != nil {
		_, _ = fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func run(args []string, stdout, stderr io.Writer) error {
	flags := flag.NewFlagSet("stickerimport", flag.ContinueOnError)
	flags.SetOutput(stderr)
	var opts options
	flags.StringVar(&opts.Source, "source", "./data/stickers", "PWM raw sticker dataset root")
	flags.StringVar(&opts.Config, "config", "./app/tool/stickerimport/stickerimport.yaml", "native PWM importer config")
	flags.BoolVar(&opts.DryRun, "dry-run", false, "parse and validate the complete source without mutating storage")
	flags.BoolVar(&opts.Resume, "resume", false, "resume a durable import using persisted source mappings")
	flags.BoolVar(&opts.Verify, "verify", false, "verify persisted documents and downloadable object ranges")
	flags.IntVar(&opts.Workers, "workers", runtime.NumCPU(), "maximum concurrent document workers")
	flags.StringVar(&opts.SetID, "set-id", "", "import one source sticker-set ID after validating the complete dataset")
	flags.IntVar(&opts.Offset, "offset", 0, "skip source sticker sets before applying limit")
	flags.IntVar(&opts.Limit, "limit", 0, "limit selected sets after validating the complete dataset")
	flags.BoolVar(&opts.CatalogOnly, "catalog-only", false, "publish global reactions, featured sets, and keywords after sticker sets are imported")
	flags.BoolVar(&opts.ReadyCheck, "ready-check", false, "verify importer MySQL and service discovery dependencies")
	if err := flags.Parse(args); err != nil {
		return err
	}
	if flags.NArg() != 0 {
		return fmt.Errorf("unexpected positional arguments: %s", strings.Join(flags.Args(), " "))
	}
	if opts.Workers <= 0 {
		return errors.New("-workers must be greater than zero")
	}
	if opts.Limit < 0 {
		return errors.New("-limit must be zero or greater")
	}
	if opts.Offset < 0 {
		return errors.New("-offset must be zero or greater")
	}

	if opts.ReadyCheck {
		return checkReady(opts.Config)
	}

	dataset, err := pwm.Load(opts.Source)
	if err != nil {
		return fmt.Errorf("PWM preflight failed: %w", err)
	}
	selected, err := selectedSetIndices(dataset, opts.SetID, opts.Offset, opts.Limit)
	if err != nil {
		return err
	}
	fingerprint, err := pwm.BuildFingerprint(dataset)
	if err != nil {
		return fmt.Errorf("fingerprint PWM source: %w", err)
	}
	if opts.DryRun {
		result := dryRunResult{
			Source:       dataset.Root,
			Version:      dataset.Version,
			Checksum:     fmt.Sprintf("%x", fingerprint.Dataset),
			Config:       opts.Config,
			Resume:       opts.Resume,
			Verify:       opts.Verify,
			Workers:      opts.Workers,
			SetID:        opts.SetID,
			Offset:       opts.Offset,
			Limit:        opts.Limit,
			SelectedSets: len(selected),
			Report:       dataset.Report,
		}
		return encodeJSON(stdout, result)
	}

	configBytes, err := os.ReadFile(opts.Config)
	if err != nil {
		return fmt.Errorf("load native importer config %q: %w", opts.Config, err)
	}
	expandedConfig := os.ExpandEnv(string(configBytes))
	var cfg config
	if err = conf.LoadFromYamlBytes([]byte(expandedConfig), &cfg); err != nil {
		return fmt.Errorf("load native importer config %q: %w", opts.Config, err)
	}
	verifyTimeout, err := time.ParseDuration(cfg.VerifyTimeout)
	if err != nil || verifyTimeout <= 0 {
		return fmt.Errorf("config VerifyTimeout must be a positive duration: %q", cfg.VerifyTimeout)
	}

	ctx := context.Background()
	store, err := catalog.Open(cfg.Mysql.DSN, catalog.DBOptions{
		MaxOpenConns:    cfg.Mysql.Active,
		MaxIdleConns:    cfg.Mysql.Idle,
		ConnMaxLifetime: parseOptionalDuration(cfg.Mysql.IdleTimeout),
	})
	if err != nil {
		return fmt.Errorf("open importer catalog: %w", err)
	}
	defer store.Close()
	if err = store.Ping(ctx); err != nil {
		return fmt.Errorf("ping importer MySQL: %w", err)
	}
	dfsRPC, err := zrpc.NewClient(cfg.DfsClient)
	if err != nil {
		return fmt.Errorf("create DFS client: %w", err)
	}
	mediaRPC, err := zrpc.NewClient(cfg.MediaClient)
	if err != nil {
		return fmt.Errorf("create media client: %w", err)
	}
	idgenRPC, err := zrpc.NewClient(cfg.IdgenClient)
	if err != nil {
		return fmt.Errorf("create idgen client: %w", err)
	}
	uploader := native.NewUploader(
		dfsclient.NewDfsClient(dfsRPC),
		mediaclient.NewMediaClient(mediaRPC),
		native.Options{
			OwnerID:       cfg.OwnerID,
			PartSize:      cfg.PartSize,
			VerifyBytes:   true,
			VerifyTimeout: verifyTimeout,
		})
	service := importer.New(store, uploader, &idGenerator{client: idgenclient.NewIdgenClient(idgenRPC)}, importer.Options{
		Workers:     opts.Workers,
		Reverify:    opts.Verify,
		CatalogOnly: opts.CatalogOnly,
	})
	report, err := service.ImportSets(ctx, dataset, fingerprint, selected)
	if err != nil {
		return err
	}
	return encodeJSON(stdout, importResult{
		Source:      dataset.Root,
		Version:     dataset.Version,
		Fingerprint: fmt.Sprintf("%x", fingerprint.Dataset),
		Report:      *report,
	})
}

func checkReady(configPath string) error {
	configBytes, err := os.ReadFile(configPath)
	if err != nil {
		return fmt.Errorf("load native importer config %q: %w", configPath, err)
	}
	var cfg config
	if err = conf.LoadFromYamlBytes([]byte(os.ExpandEnv(string(configBytes))), &cfg); err != nil {
		return fmt.Errorf("load native importer config %q: %w", configPath, err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	store, err := catalog.Open(cfg.Mysql.DSN, catalog.DBOptions{MaxOpenConns: 1, MaxIdleConns: 1})
	if err != nil {
		return fmt.Errorf("open importer catalog: %w", err)
	}
	defer store.Close()
	if err = store.Ping(ctx); err != nil {
		return fmt.Errorf("ping importer MySQL: %w", err)
	}
	idgenRPC, err := zrpc.NewClient(cfg.IdgenClient)
	if err != nil {
		return fmt.Errorf("create idgen client: %w", err)
	}
	if _, err = (&idGenerator{client: idgenclient.NewIdgenClient(idgenRPC)}).NextID(ctx); err != nil {
		return fmt.Errorf("probe idgen service: %w", err)
	}
	return nil
}

func selectedSetCount(dataset *pwm.Dataset, setID string, offset, limit int) (int, error) {
	selected, err := selectedSetIndices(dataset, setID, offset, limit)
	return len(selected), err
}

func selectedSetIndices(dataset *pwm.Dataset, setID string, offset, limit int) ([]int, error) {
	selected := make([]int, 0, len(dataset.Sets))
	if setID != "" {
		for index := range dataset.Sets {
			if dataset.Sets[index].Set.ID == setID {
				selected = append(selected, index)
				break
			}
		}
		if len(selected) == 0 {
			return nil, fmt.Errorf("source sticker set %q was not found", setID)
		}
	} else {
		if offset > len(dataset.Sets) {
			offset = len(dataset.Sets)
		}
		for index := offset; index < len(dataset.Sets); index++ {
			selected = append(selected, index)
		}
	}
	if limit > 0 && len(selected) > limit {
		selected = selected[:limit]
	}
	return selected, nil
}

type idGenerator struct {
	client idgenclient.IdgenClient
}

func (g *idGenerator) NextID(ctx context.Context) (int64, error) {
	result, err := g.client.IdgenNextId(ctx, &idgen.TLIdgenNextId{})
	if err != nil {
		return 0, err
	}
	if result.GetV() <= 0 {
		return 0, errors.New("idgen returned a non-positive ID")
	}
	return result.GetV(), nil
}

func encodeJSON(writer io.Writer, value any) error {
	encoder := json.NewEncoder(writer)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(value); err != nil {
		return fmt.Errorf("write importer report: %w", err)
	}
	return nil
}

func parseOptionalDuration(value string) time.Duration {
	duration, _ := time.ParseDuration(value)
	return duration
}
