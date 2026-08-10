package pwm

import (
	"crypto/sha256"
	"encoding/binary"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
)

type Fingerprint struct {
	Dataset [sha256.Size]byte
	Files   map[string][sha256.Size]byte
}

// BuildFingerprint hashes every source file which can affect the imported
// native catalog. Paths are normalized relative to the dataset root and
// sorted, making the fingerprint independent from filesystem enumeration.
func BuildFingerprint(dataset *Dataset) (*Fingerprint, error) {
	if dataset == nil || dataset.Root == "" {
		return nil, fmt.Errorf("dataset root is required")
	}
	paths := map[string]struct{}{
		filepath.Join(dataset.Root, "version.txt"):                          {},
		filepath.Join(dataset.Root, "json_data", "availableReactions.json"): {},
		filepath.Join(dataset.Root, "json_data", "emojiKeywords.json"):      {},
	}
	for _, set := range dataset.Sets {
		paths[set.SourcePath] = struct{}{}
		for _, document := range set.Stickers {
			paths[document.SourcePath] = struct{}{}
			if document.PreviewPath != "" {
				paths[document.PreviewPath] = struct{}{}
			}
		}
	}
	for _, reaction := range dataset.Reactions {
		for _, document := range reaction.Documents() {
			if document.ID == "" {
				continue
			}
			paths[document.SourcePath] = struct{}{}
			if document.PreviewPath != "" {
				paths[document.PreviewPath] = struct{}{}
			}
		}
	}
	for name := range dataset.Auxiliary {
		paths[filepath.Join(dataset.Root, "json_data", name)] = struct{}{}
	}

	ordered := make([]string, 0, len(paths))
	for path := range paths {
		if path == "" {
			continue
		}
		ordered = append(ordered, path)
	}
	sort.Strings(ordered)

	result := &Fingerprint{Files: make(map[string][sha256.Size]byte, len(ordered))}
	datasetHash := sha256.New()
	var sizeBuffer [8]byte
	for _, path := range ordered {
		if err := validateContainedPath(dataset.Root, path); err != nil {
			return nil, err
		}
		relative, err := filepath.Rel(dataset.Root, path)
		if err != nil || relative == "." || relative == ".." || filepath.IsAbs(relative) {
			return nil, fmt.Errorf("source path %q is outside dataset root %q", path, dataset.Root)
		}
		file, err := os.Open(path)
		if err != nil {
			return nil, fmt.Errorf("open fingerprint source %q: %w", path, err)
		}
		stat, statErr := file.Stat()
		if statErr != nil {
			_ = file.Close()
			return nil, fmt.Errorf("stat fingerprint source %q: %w", path, statErr)
		}
		fileHash := sha256.New()
		if _, err = io.Copy(fileHash, file); err != nil {
			_ = file.Close()
			return nil, fmt.Errorf("hash fingerprint source %q: %w", path, err)
		}
		if err = file.Close(); err != nil {
			return nil, fmt.Errorf("close fingerprint source %q: %w", path, err)
		}
		var checksum [sha256.Size]byte
		copy(checksum[:], fileHash.Sum(nil))
		result.Files[path] = checksum

		_, _ = datasetHash.Write([]byte(filepath.ToSlash(relative)))
		_, _ = datasetHash.Write([]byte{0})
		binary.BigEndian.PutUint64(sizeBuffer[:], uint64(stat.Size()))
		_, _ = datasetHash.Write(sizeBuffer[:])
		_, _ = datasetHash.Write(checksum[:])
	}
	copy(result.Dataset[:], datasetHash.Sum(nil))
	return result, nil
}
