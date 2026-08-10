package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"strings"
	"time"

	"github.com/teamgram/proto/mtproto"
	rpcmetadata "github.com/teamgram/proto/mtproto/rpc/metadata"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/credentials/insecure"
)

const layer = 186

type options struct {
	endpoint          string
	userID            int64
	stickerSetID      int64
	stickerSetAccess  int64
	documentID        int64
	documentAccess    int64
	langCode          string
	timeout           time.Duration
	insecureTransport bool
	tlsServerName     string
}

func parseOptions(args []string) (options, error) {
	var opts options
	fs := flag.NewFlagSet("nativecatalogprobe", flag.ContinueOnError)
	fs.SetOutput(io.Discard)
	fs.StringVar(&opts.endpoint, "endpoint", "", "BFF PWM gRPC host:port")
	fs.Int64Var(&opts.userID, "user-id", 0, "user ID placed in rpc_metadata")
	fs.Int64Var(&opts.stickerSetID, "sticker-set-id", 0, "optional native sticker set ID")
	fs.Int64Var(&opts.stickerSetAccess, "sticker-set-access-hash", 0, "optional native sticker set access hash")
	fs.Int64Var(&opts.documentID, "document-id", 0, "optional custom emoji document ID")
	fs.Int64Var(&opts.documentAccess, "document-access-hash", 0, "optional expected document access hash")
	fs.StringVar(&opts.langCode, "lang-code", "en", "emoji keyword language code")
	fs.DurationVar(&opts.timeout, "timeout", 10*time.Second, "total RPC timeout")
	fs.BoolVar(&opts.insecureTransport, "insecure", false, "use plaintext gRPC (internal trusted network only)")
	fs.StringVar(&opts.tlsServerName, "tls-server-name", "", "optional TLS server-name override")
	if err := fs.Parse(args); err != nil {
		return options{}, err
	}
	if fs.NArg() != 0 {
		return options{}, fmt.Errorf("unexpected positional arguments: %s", strings.Join(fs.Args(), " "))
	}
	opts.endpoint = strings.TrimSpace(opts.endpoint)
	opts.langCode = strings.TrimSpace(opts.langCode)
	if opts.endpoint == "" {
		return options{}, errors.New("-endpoint is required")
	}
	if opts.userID <= 0 {
		return options{}, errors.New("-user-id must be greater than zero")
	}
	if opts.timeout <= 0 {
		return options{}, errors.New("-timeout must be greater than zero")
	}
	if opts.langCode == "" || len(opts.langCode) > 16 {
		return options{}, errors.New("-lang-code must contain 1 to 16 characters")
	}
	if (opts.stickerSetID == 0) != (opts.stickerSetAccess == 0) {
		return options{}, errors.New("-sticker-set-id and -sticker-set-access-hash must be provided together")
	}
	if opts.stickerSetID < 0 {
		return options{}, errors.New("-sticker-set-id must be greater than zero")
	}
	if opts.documentID < 0 {
		return options{}, errors.New("-document-id must be greater than zero")
	}
	if opts.documentAccess != 0 && opts.documentID == 0 {
		return options{}, errors.New("-document-access-hash requires -document-id")
	}
	return opts, nil
}

func main() {
	if err := run(os.Args[1:], os.Stdout); err != nil {
		fmt.Fprintf(os.Stderr, "native catalog probe failed: %v\n", err)
		os.Exit(1)
	}
}

func run(args []string, out io.Writer) error {
	opts, err := parseOptions(args)
	if err != nil {
		return fmt.Errorf("%w\nusage: nativecatalogprobe -endpoint host:port -user-id ID [-insecure] [-sticker-set-id ID -sticker-set-access-hash HASH] [-document-id ID [-document-access-hash HASH]] [-lang-code en] [-timeout 10s]", err)
	}

	transport := credentials.NewTLS(nil)
	if opts.tlsServerName != "" {
		transport = credentials.NewTLS((tlsConfig{serverName: opts.tlsServerName}).config())
	}
	dialOption := grpc.WithTransportCredentials(transport)
	if opts.insecureTransport {
		dialOption = grpc.WithTransportCredentials(insecure.NewCredentials())
	}
	conn, err := grpc.Dial(opts.endpoint, dialOption)
	if err != nil {
		return fmt.Errorf("connect to %s: %w", opts.endpoint, err)
	}
	defer conn.Close()

	ctx, cancel := context.WithTimeout(context.Background(), opts.timeout)
	defer cancel()
	ctx, err = rpcmetadata.RpcMetadataToOutgoing(ctx, &rpcmetadata.RpcMetadata{
		ServerId:    "nativecatalogprobe",
		ClientAddr:  "nativecatalogprobe",
		ReceiveTime: time.Now().Unix(),
		UserId:      opts.userID,
		Layer:       layer,
		Client:      "nativecatalogprobe",
		Langpack:    opts.langCode,
	})
	if err != nil {
		return fmt.Errorf("encode rpc metadata: %w", err)
	}

	stickers := mtproto.NewRPCStickersClient(conn)
	all, err := stickers.MessagesGetAllStickers(ctx, &mtproto.TLMessagesGetAllStickers{Hash: 0})
	if err != nil {
		return fmt.Errorf("MessagesGetAllStickers: %w", err)
	}
	if err = validateAllStickers(all); err != nil {
		return fmt.Errorf("MessagesGetAllStickers: %w", err)
	}
	fmt.Fprintf(out, "PASS MessagesGetAllStickers sets=%d\n", len(all.GetSets()))

	if opts.stickerSetID != 0 {
		set, callErr := stickers.MessagesGetStickerSet(ctx, &mtproto.TLMessagesGetStickerSet{
			Stickerset: mtproto.MakeTLInputStickerSetID(&mtproto.InputStickerSet{Id: opts.stickerSetID, AccessHash: opts.stickerSetAccess}).To_InputStickerSet(),
			Hash:       0,
		})
		if callErr != nil {
			return fmt.Errorf("MessagesGetStickerSet: %w", callErr)
		}
		if err = validateStickerSet(set, opts.stickerSetID); err != nil {
			return fmt.Errorf("MessagesGetStickerSet: %w", err)
		}
		fmt.Fprintf(out, "PASS MessagesGetStickerSet documents=%d\n", len(set.GetDocuments()))
	}

	reactions, err := mtproto.NewRPCReactionsClient(conn).MessagesGetAvailableReactions(ctx, &mtproto.TLMessagesGetAvailableReactions{Hash: 0})
	if err != nil {
		return fmt.Errorf("MessagesGetAvailableReactions: %w", err)
	}
	if err = validateAvailableReactions(reactions); err != nil {
		return fmt.Errorf("MessagesGetAvailableReactions: %w", err)
	}
	fmt.Fprintf(out, "PASS MessagesGetAvailableReactions reactions=%d\n", len(reactions.GetReactions()))

	keywords, err := mtproto.NewRPCEmojiClient(conn).MessagesGetEmojiKeywordsDifference(ctx, &mtproto.TLMessagesGetEmojiKeywordsDifference{LangCode: opts.langCode, FromVersion: 0})
	if err != nil {
		return fmt.Errorf("MessagesGetEmojiKeywordsDifference: %w", err)
	}
	if err = validateEmojiKeywords(keywords, opts.langCode); err != nil {
		return fmt.Errorf("MessagesGetEmojiKeywordsDifference: %w", err)
	}
	fmt.Fprintf(out, "PASS MessagesGetEmojiKeywordsDifference keywords=%d version=%d\n", len(keywords.GetKeywords()), keywords.GetVersion())

	if opts.documentID != 0 {
		documents, callErr := mtproto.NewRPCCustomEmojisClient(conn).MessagesGetCustomEmojiDocuments(ctx, &mtproto.TLMessagesGetCustomEmojiDocuments{DocumentId: []int64{opts.documentID}})
		if callErr != nil {
			return fmt.Errorf("MessagesGetCustomEmojiDocuments: %w", callErr)
		}
		if err = validateCustomEmojiDocuments(documents, opts.documentID, opts.documentAccess); err != nil {
			return fmt.Errorf("MessagesGetCustomEmojiDocuments: %w", err)
		}
		fmt.Fprintln(out, "PASS MessagesGetCustomEmojiDocuments documents=1 media_descriptor=hydrated")

		file, callErr := mtproto.NewRPCFilesClient(conn).UploadGetFile(ctx, &mtproto.TLUploadGetFile{
			Location: mtproto.MakeTLInputDocumentFileLocation(&mtproto.InputFileLocation{
				Id: opts.documentID, AccessHash: documents.GetDatas()[0].GetAccessHash(),
				FileReference: documents.GetDatas()[0].GetFileReference(),
			}).To_InputFileLocation(),
			Offset_INT64: 0,
			Limit:        4096,
		})
		if callErr != nil {
			return fmt.Errorf("UploadGetFile: %w", callErr)
		}
		if file == nil || len(file.GetBytes()) == 0 {
			return errors.New("UploadGetFile: native document returned no bytes")
		}
		fmt.Fprintf(out, "PASS UploadGetFile bytes=%d\n", len(file.GetBytes()))
	}

	return nil
}

func validateAllStickers(result *mtproto.Messages_AllStickers) error {
	if result == nil {
		return errors.New("expected typed messages.allStickers result, got nil")
	}
	if len(result.GetSets()) == 0 {
		return errors.New("sticker set catalog is empty")
	}
	for _, set := range result.GetSets() {
		if set == nil || set.GetId() == 0 || set.GetAccessHash() == 0 || strings.TrimSpace(set.GetTitle()) == "" {
			return errors.New("sticker set catalog contains an unhydrated set")
		}
	}
	return nil
}

func validateStickerSet(result *mtproto.Messages_StickerSet, expectedID int64) error {
	if result == nil || result.GetSet() == nil {
		return errors.New("expected typed messages.stickerSet result")
	}
	if result.GetSet() == nil || result.GetSet().GetId() != expectedID {
		return errors.New("sticker set identity does not match request")
	}
	if len(result.GetDocuments()) == 0 {
		return errors.New("sticker set has no documents")
	}
	for _, document := range result.GetDocuments() {
		if err := validateDocument(document, 0, 0); err != nil {
			return err
		}
	}
	return nil
}

func validateAvailableReactions(result *mtproto.Messages_AvailableReactions) error {
	if result == nil {
		return errors.New("expected typed messages.availableReactions result")
	}
	if len(result.GetReactions()) == 0 {
		return errors.New("reaction catalog is empty")
	}
	for _, reaction := range result.GetReactions() {
		if reaction == nil || strings.TrimSpace(reaction.GetReaction()) == "" {
			return errors.New("reaction catalog contains an invalid reaction")
		}
		for _, document := range []*mtproto.Document{reaction.GetStaticIcon(), reaction.GetAppearAnimation(), reaction.GetSelectAnimation(), reaction.GetActivateAnimation(), reaction.GetEffectAnimation()} {
			if err := validateDocument(document, 0, 0); err != nil {
				return fmt.Errorf("reaction %q: %w", reaction.GetReaction(), err)
			}
		}
	}
	return nil
}

func validateEmojiKeywords(result *mtproto.EmojiKeywordsDifference, langCode string) error {
	if result == nil {
		return errors.New("expected typed emojiKeywordsDifference result")
	}
	if result.GetLangCode() != langCode || result.GetVersion() <= 0 || len(result.GetKeywords()) == 0 {
		return errors.New("emoji keyword catalog is empty or has invalid version/language")
	}
	for _, keyword := range result.GetKeywords() {
		if keyword == nil || strings.TrimSpace(keyword.GetKeyword()) == "" || len(keyword.GetEmoticons()) == 0 {
			return errors.New("emoji keyword catalog contains an invalid keyword")
		}
	}
	return nil
}

func validateCustomEmojiDocuments(result *mtproto.Vector_Document, expectedID, expectedAccessHash int64) error {
	if result == nil || len(result.GetDatas()) != 1 {
		return errors.New("expected exactly one custom emoji document")
	}
	return validateDocument(result.GetDatas()[0], expectedID, expectedAccessHash)
}

func validateDocument(document *mtproto.Document, expectedID, expectedAccessHash int64) error {
	if document == nil {
		return errors.New("expected hydrated document")
	}
	size := document.GetSize2()
	if size == 0 {
		size = document.GetSize2_INT64()
	}
	if size == 0 {
		size = int64(document.GetSize2_INT32())
	}
	if document.GetId() == 0 || document.GetAccessHash() == 0 || document.GetDcId() <= 0 || size <= 0 || strings.TrimSpace(document.GetMimeType()) == "" {
		return fmt.Errorf("document media descriptor is incomplete: id=%d access_hash_set=%t dc_id=%d size=%d mime_set=%t",
			document.GetId(), document.GetAccessHash() != 0, document.GetDcId(), size, strings.TrimSpace(document.GetMimeType()) != "")
	}
	if expectedID != 0 && document.GetId() != expectedID {
		return errors.New("document identity does not match request")
	}
	if expectedAccessHash != 0 && document.GetAccessHash() != expectedAccessHash {
		return errors.New("document access hash does not match request")
	}
	return nil
}
