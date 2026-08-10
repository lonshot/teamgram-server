package pwm

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
)

var auxiliaryFiles = []string{
	"animatedEmojis.json",
	"featuredStickers.json",
	"topReactions.json",
}

func Load(root string) (*Dataset, error) {
	absRoot, err := filepath.Abs(root)
	if err != nil {
		return nil, fmt.Errorf("resolve PWM source %q: %w", root, err)
	}
	rootInfo, err := os.Lstat(absRoot)
	if err != nil {
		return nil, fmt.Errorf("validate PWM source root %q: %w", absRoot, err)
	}
	if rootInfo.Mode()&os.ModeSymlink != 0 {
		return nil, fmt.Errorf("PWM source root %q is a symlink", absRoot)
	}

	canonicalRoot, err := filepath.EvalSymlinks(absRoot)
	if err != nil {
		return nil, fmt.Errorf("resolve canonical PWM source %q: %w", absRoot, err)
	}
	dataset := &Dataset{Root: canonicalRoot, Auxiliary: make(map[string]json.RawMessage)}
	var validationErrors []error

	versionBytes, err := os.ReadFile(filepath.Join(absRoot, "version.txt"))
	if err != nil {
		validationErrors = append(validationErrors, fmt.Errorf("read dataset version %q: %w", filepath.Join(absRoot, "version.txt"), err))
	} else if dataset.Version = strings.TrimSpace(string(versionBytes)); dataset.Version == "" {
		validationErrors = append(validationErrors, fmt.Errorf("dataset version %q is empty", filepath.Join(absRoot, "version.txt")))
	}

	jsonDir := filepath.Join(absRoot, "json_data")
	for _, dir := range []string{jsonDir, filepath.Join(absRoot, "tgs"), filepath.Join(absRoot, "preview")} {
		if stat, statErr := os.Stat(dir); statErr != nil {
			validationErrors = append(validationErrors, fmt.Errorf("validate source directory %q: %w", dir, statErr))
		} else if !stat.IsDir() {
			validationErrors = append(validationErrors, fmt.Errorf("source path %q is not a directory", dir))
		}
	}

	setFiles, globErr := filepath.Glob(filepath.Join(jsonDir, "stickerSet-*.json"))
	if globErr != nil {
		validationErrors = append(validationErrors, fmt.Errorf("enumerate sticker sets in %q: %w", jsonDir, globErr))
	}
	sort.Strings(setFiles)
	dataset.Report.SetFiles = len(setFiles)
	if len(setFiles) == 0 {
		validationErrors = append(validationErrors, fmt.Errorf("PWM source %q contains no stickerSet-*.json files", jsonDir))
	}

	setIDs := make(map[string]string)
	shortNames := make(map[string]string)
	documentOwners := make(map[string]string)

	for _, path := range setFiles {
		path, err = filepath.EvalSymlinks(path)
		if err != nil {
			validationErrors = append(validationErrors, fmt.Errorf("resolve sticker set source %q: %w", path, err))
			continue
		}
		var source StickerSetFile
		if readErr := readJSON(path, &source); readErr != nil {
			validationErrors = append(validationErrors, readErr)
			continue
		}
		source.SourcePath = path
		if setErrs := validateStickerSet(dataset, &source, setIDs, shortNames, documentOwners); len(setErrs) != 0 {
			validationErrors = append(validationErrors, setErrs...)
		}
		dataset.Sets = append(dataset.Sets, source)
	}
	dataset.Report.StickerSets = len(dataset.Sets)

	reactionsPath := filepath.Join(jsonDir, "availableReactions.json")
	if readErr := readJSON(reactionsPath, &dataset.Reactions); readErr != nil {
		validationErrors = append(validationErrors, readErr)
	} else {
		dataset.Report.AvailableReactions = len(dataset.Reactions)
		for reactionIndex := range dataset.Reactions {
			reaction := &dataset.Reactions[reactionIndex]
			if strings.TrimSpace(reaction.Reaction.Emoticon) == "" {
				validationErrors = append(validationErrors, fmt.Errorf("%s: reaction[%d] has an empty emoticon", reactionsPath, reactionIndex))
			}
			for documentIndex, document := range reaction.Documents() {
				if document.ID == "" {
					continue
				}
				owner := fmt.Sprintf("%s reaction[%d] document[%d]", reactionsPath, reactionIndex, documentIndex)
				if documentErr := validateReactionDocument(dataset, document, owner, documentOwners); documentErr != nil {
					validationErrors = append(validationErrors, documentErr)
				}
			}
		}
	}

	emojiPath := filepath.Join(jsonDir, "emojiKeywords.json")
	if readErr := readJSON(emojiPath, &dataset.EmojiKeywords); readErr != nil {
		validationErrors = append(validationErrors, readErr)
	} else {
		if strings.TrimSpace(dataset.EmojiKeywords.Language) == "" {
			validationErrors = append(validationErrors, fmt.Errorf("%s: language is empty", emojiPath))
		}
		if dataset.EmojiKeywords.Version <= 0 {
			validationErrors = append(validationErrors, fmt.Errorf("%s: version must be positive", emojiPath))
		}
		dataset.Report.EmojiKeywords = len(dataset.EmojiKeywords.Keywords)
	}

	featuredPath := filepath.Join(jsonDir, "featuredStickers.json")
	if readErr := readJSON(featuredPath, &dataset.Featured); readErr != nil {
		validationErrors = append(validationErrors, readErr)
	} else {
		featuredIDs := make(map[string]struct{}, len(dataset.Featured.Sets))
		for setIndex := range dataset.Featured.Sets {
			featured := &dataset.Featured.Sets[setIndex]
			owner := fmt.Sprintf("%s set[%d]", featuredPath, setIndex)
			id, idErr := parseSourceID(featured.ID)
			if idErr != nil {
				validationErrors = append(validationErrors, fmt.Errorf("%s id %q: %w", owner, featured.ID, idErr))
				continue
			}
			featured.SourceID = id
			if _, exists := setIDs[featured.ID]; !exists {
				validationErrors = append(validationErrors, fmt.Errorf("%s references unknown sticker set %q", owner, featured.ID))
			}
			if _, duplicate := featuredIDs[featured.ID]; duplicate {
				validationErrors = append(validationErrors, fmt.Errorf("%s duplicates featured sticker set %q", owner, featured.ID))
			}
			featuredIDs[featured.ID] = struct{}{}
			coverIDs := make(map[string]struct{}, len(featured.Covers))
			for coverIndex := range featured.Covers {
				cover := &featured.Covers[coverIndex]
				coverOwner := fmt.Sprintf("%s cover[%d]", owner, coverIndex)
				coverID, coverErr := parseSourceID(cover.ID)
				if coverErr != nil {
					validationErrors = append(validationErrors, fmt.Errorf("%s id %q: %w", coverOwner, cover.ID, coverErr))
					continue
				}
				cover.SourceID = coverID
				if _, exists := documentOwners[cover.ID]; !exists {
					validationErrors = append(validationErrors, fmt.Errorf("%s references unknown sticker document %q", coverOwner, cover.ID))
				}
				if _, duplicate := coverIDs[cover.ID]; duplicate {
					validationErrors = append(validationErrors, fmt.Errorf("%s duplicates cover document %q", coverOwner, cover.ID))
				}
				coverIDs[cover.ID] = struct{}{}
			}
		}
		dataset.Report.FeaturedSets = len(dataset.Featured.Sets)
	}

	for _, name := range auxiliaryFiles {
		path := filepath.Join(jsonDir, name)
		var raw json.RawMessage
		if readErr := readJSON(path, &raw); readErr != nil {
			validationErrors = append(validationErrors, readErr)
			continue
		}
		dataset.Auxiliary[name] = raw
	}

	dataset.Report.UniqueDocuments = len(documentOwners)
	return dataset, errors.Join(validationErrors...)
}

func readJSON(path string, target any) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return fmt.Errorf("read PWM JSON %q: %w", path, err)
	}
	if len(data) == 0 {
		return fmt.Errorf("PWM JSON %q is empty", path)
	}
	if err = json.Unmarshal(data, target); err != nil {
		return fmt.Errorf("parse PWM JSON %q: %w", path, err)
	}
	return nil
}

func validateStickerSet(dataset *Dataset, source *StickerSetFile, setIDs, shortNames, documentOwners map[string]string) []error {
	var result []error
	owner := source.SourcePath
	set := &source.Set

	if set.ID == "" {
		result = append(result, fmt.Errorf("%s: sticker set id is empty", owner))
	} else if id, err := parseSourceID(set.ID); err != nil {
		result = append(result, fmt.Errorf("%s: sticker set id %q: %w", owner, set.ID, err))
	} else {
		set.SourceID = id
		if previous, exists := setIDs[set.ID]; exists {
			result = append(result, fmt.Errorf("%s: duplicate sticker set id %q (already in %s)", owner, set.ID, previous))
		} else {
			setIDs[set.ID] = owner
		}
	}
	if hash, err := strconv.ParseInt(set.AccessHash, 10, 64); err != nil {
		result = append(result, fmt.Errorf("%s: sticker set access hash %q: %w", owner, set.AccessHash, err))
	} else {
		set.SourceAccessHash = hash
	}
	normalizedShortName := strings.ToLower(strings.TrimSpace(set.ShortName))
	if normalizedShortName == "" {
		result = append(result, fmt.Errorf("%s: sticker set short name is empty", owner))
	} else if previous, exists := shortNames[normalizedShortName]; exists {
		result = append(result, fmt.Errorf("%s: duplicate normalized short name %q (already in %s)", owner, normalizedShortName, previous))
	} else {
		shortNames[normalizedShortName] = owner
	}
	if int(set.Count) != len(source.Stickers) {
		result = append(result, fmt.Errorf("%s: sticker count is %d, JSON contains %d documents", owner, set.Count, len(source.Stickers)))
	}

	for index := range source.Stickers {
		document := &source.Stickers[index]
		dataset.Report.StickerDocuments++
		documentOwner := fmt.Sprintf("%s sticker[%d]", owner, index)
		if document.ID == "" {
			result = append(result, fmt.Errorf("%s: document id is empty", documentOwner))
			continue
		}
		if id, err := parseSourceID(document.ID); err != nil {
			result = append(result, fmt.Errorf("%s: document id %q: %w", documentOwner, document.ID, err))
		} else {
			document.SourceID = id
		}
		if previous, exists := documentOwners[document.ID]; exists {
			result = append(result, fmt.Errorf("%s: duplicate source document id %q (already in %s)", documentOwner, document.ID, previous))
		} else {
			documentOwners[document.ID] = documentOwner
		}
		if document.StickerSetInfo.ID != set.ID || document.StickerSetInfo.AccessHash != set.AccessHash {
			result = append(result, fmt.Errorf("%s: stickerSetInfo (%q, %q) does not match parent (%q, %q)", documentOwner, document.StickerSetInfo.ID, document.StickerSetInfo.AccessHash, set.ID, set.AccessHash))
		}
		if document.Width <= 0 || document.Height <= 0 {
			result = append(result, fmt.Errorf("%s: invalid dimensions %dx%d", documentOwner, document.Width, document.Height))
		}
		if thumbnailErr := pathBytesFromThumbnail(document.Thumbnail, document.Width, document.Height); thumbnailErr != nil {
			result = append(result, fmt.Errorf("%s: %w", documentOwner, thumbnailErr))
		} else if document.Thumbnail != nil {
			dataset.Report.PathThumbnails++
		}
		if document.IsVideo {
			dataset.Report.UnsupportedVideos++
			continue
		}
		path, mimeType := stickerAssetPath(dataset.Root, document)
		document.SourcePath = path
		if document.MimeType == "" {
			document.MimeType = mimeType
		} else if document.MimeType != mimeType {
			result = append(result, fmt.Errorf("%s: MIME type %q conflicts with source kind %q", documentOwner, document.MimeType, mimeType))
		}
		if statErr := validateAsset(dataset, path, document.Size, &document.SourceSize); statErr != nil {
			result = append(result, fmt.Errorf("%s source document %q: %w", documentOwner, document.ID, statErr))
		}
		previewPath := filepath.Join(dataset.Root, "preview", "sticker"+document.ID)
		document.PreviewPath = previewPath
		if previewPath == document.SourcePath {
			document.PreviewSize = document.SourceSize
			dataset.Report.StickerPreviews++
			dataset.Report.ReferencedPreviewBytes += document.PreviewSize
		} else if previewErr := validatePreviewAsset(dataset, previewPath, &document.PreviewSize); previewErr != nil {
			result = append(result, fmt.Errorf("%s preview document %q: %w", documentOwner, document.ID, previewErr))
		} else if document.PreviewSize == 0 {
			document.PreviewPath = ""
			dataset.Report.MissingPreviews++
		} else {
			dataset.Report.StickerPreviews++
		}
	}
	return result
}

func validateReactionDocument(dataset *Dataset, document *ReactionDocument, owner string, documentOwners map[string]string) error {
	id, err := parseSourceID(document.ID)
	if err != nil {
		return fmt.Errorf("%s: document id %q: %w", owner, document.ID, err)
	}
	document.SourceID = id
	width, height := document.MediaSize.Width, document.MediaSize.Height
	if document.Thumbnail != nil {
		if width == 0 {
			width = document.Thumbnail.Width
		}
		if height == 0 {
			height = document.Thumbnail.Height
		}
		if thumbnailErr := pathBytesFromThumbnail(document.Thumbnail, width, height); thumbnailErr != nil {
			return fmt.Errorf("%s: %w", owner, thumbnailErr)
		}
		dataset.Report.PathThumbnails++
	}
	path, mimeType, err := reactionAssetPath(dataset.Root, document)
	if err != nil {
		return fmt.Errorf("%s source document %q: %w", owner, document.ID, err)
	}
	document.SourcePath = path
	if document.MimeType == "" {
		document.MimeType = mimeType
	} else if document.MimeType != mimeType {
		return fmt.Errorf("%s: MIME type %q conflicts with asset path MIME %q", owner, document.MimeType, mimeType)
	}
	if previous, exists := documentOwners[document.ID]; exists {
		return fmt.Errorf("%s: duplicate source document id %q (already in %s)", owner, document.ID, previous)
	}
	documentOwners[document.ID] = owner
	dataset.Report.ReactionDocuments++
	if err = validateAsset(dataset, path, document.Size, &document.SourceSize); err != nil {
		return fmt.Errorf("%s source document %q: %w", owner, document.ID, err)
	}
	document.PreviewPath = filepath.Join(dataset.Root, "preview", "document"+document.ID)
	if document.PreviewPath == document.SourcePath {
		document.PreviewSize = document.SourceSize
		dataset.Report.ReactionPreviews++
		dataset.Report.ReferencedPreviewBytes += document.PreviewSize
	} else if err = validatePreviewAsset(dataset, document.PreviewPath, &document.PreviewSize); err != nil {
		return fmt.Errorf("%s preview document %q: %w", owner, document.ID, err)
	} else if document.PreviewSize == 0 {
		document.PreviewPath = ""
		dataset.Report.MissingPreviews++
	} else {
		dataset.Report.ReactionPreviews++
	}
	return nil
}

func parseSourceID(value string) (int64, error) {
	id, err := strconv.ParseInt(value, 10, 64)
	if err != nil {
		return 0, err
	}
	if id <= 0 {
		return 0, fmt.Errorf("must be positive")
	}
	return id, nil
}

func stickerAssetPath(root string, document *StickerDoc) (string, string) {
	if document.IsLottie {
		return filepath.Join(root, "tgs", "sticker"+document.ID), MIMETypeTGS
	}
	return filepath.Join(root, "preview", "sticker"+document.ID), MIMETypeWebP
}

func reactionAssetPath(root string, document *ReactionDocument) (string, string, error) {
	switch document.MimeType {
	case "", MIMETypeTGS:
		return filepath.Join(root, "tgs", "document"+document.ID), MIMETypeTGS, nil
	case MIMETypeWebP:
		return filepath.Join(root, "preview", "document"+document.ID), MIMETypeWebP, nil
	case MIMETypeWebM:
		return "", "", fmt.Errorf("video/webm reactions are unsupported")
	default:
		return "", "", fmt.Errorf("unsupported MIME type %q", document.MimeType)
	}
}

func validateAsset(dataset *Dataset, path string, declaredSize int64, actualSize *int64) error {
	if err := validateContainedPath(dataset.Root, path); err != nil {
		return err
	}
	stat, err := os.Stat(path)
	if err != nil {
		return fmt.Errorf("validate asset %q: %w", path, err)
	}
	if !stat.Mode().IsRegular() {
		return fmt.Errorf("asset %q is not a regular file", path)
	}
	if stat.Size() <= 0 {
		return fmt.Errorf("asset %q is empty", path)
	}
	if declaredSize > 0 && declaredSize != stat.Size() {
		return fmt.Errorf("asset %q size mismatch: metadata=%d actual=%d", path, declaredSize, stat.Size())
	}
	*actualSize = stat.Size()
	dataset.Report.ReferencedAssetBytes += stat.Size()
	return nil
}

func validatePreviewAsset(dataset *Dataset, path string, actualSize *int64) error {
	if err := validateContainedPath(dataset.Root, path); err != nil {
		return err
	}
	stat, err := os.Stat(path)
	if errors.Is(err, os.ErrNotExist) {
		return nil
	}
	if err != nil {
		return fmt.Errorf("validate asset %q: %w", path, err)
	}
	if !stat.Mode().IsRegular() {
		return fmt.Errorf("asset %q is not a regular file", path)
	}
	if stat.Size() <= 0 {
		return fmt.Errorf("asset %q is empty", path)
	}
	*actualSize = stat.Size()
	dataset.Report.ReferencedAssetBytes += stat.Size()
	dataset.Report.ReferencedPreviewBytes += stat.Size()
	return nil
}

func validateContainedPath(root, path string) error {
	relative, err := filepath.Rel(root, path)
	if err != nil || relative == "." || relative == ".." || strings.HasPrefix(relative, ".."+string(filepath.Separator)) || filepath.IsAbs(relative) {
		return fmt.Errorf("asset %q is outside dataset root %q", path, root)
	}
	canonical, err := filepath.EvalSymlinks(path)
	if errors.Is(err, os.ErrNotExist) {
		parent, parentErr := filepath.EvalSymlinks(filepath.Dir(path))
		if parentErr != nil {
			return fmt.Errorf("resolve asset parent %q: %w", path, parentErr)
		}
		canonical = filepath.Join(parent, filepath.Base(path))
	} else if err != nil {
		return fmt.Errorf("resolve asset %q: %w", path, err)
	}
	canonicalRelative, err := filepath.Rel(root, canonical)
	if err != nil || canonicalRelative == ".." || strings.HasPrefix(canonicalRelative, ".."+string(filepath.Separator)) || filepath.IsAbs(canonicalRelative) {
		return fmt.Errorf("asset %q resolves outside dataset root %q", path, root)
	}
	return nil
}
