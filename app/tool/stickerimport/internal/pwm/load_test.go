package pwm

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestLoadValidDataset(t *testing.T) {
	root := makeFixture(t)

	dataset, err := Load(root)
	require.NoError(t, err)
	root = dataset.Root
	require.Equal(t, "1.0.0", dataset.Version)
	require.Len(t, dataset.Sets, 1)
	require.Equal(t, int64(42), dataset.Sets[0].Set.SourceID)
	require.Equal(t, int64(-7), dataset.Sets[0].Set.SourceAccessHash)
	require.Equal(t, int64(43), dataset.Sets[0].Stickers[0].SourceID)
	require.Equal(t, filepath.Join(root, "tgs", "sticker43"), dataset.Sets[0].Stickers[0].SourcePath)
	require.Equal(t, filepath.Join(root, "preview", "sticker43"), dataset.Sets[0].Stickers[0].PreviewPath)
	require.Equal(t, MIMETypeTGS, dataset.Sets[0].Stickers[0].MimeType)
	require.NotEmpty(t, dataset.Sets[0].Stickers[0].Thumbnail.PathBytes)
	require.Equal(t, "M10,20z", decodePathBytes(dataset.Sets[0].Stickers[0].Thumbnail.PathBytes))
	require.Equal(t, 1, dataset.Report.StickerSets)
	require.Equal(t, 1, dataset.Report.StickerDocuments)
	require.Equal(t, 1, dataset.Report.ReactionDocuments)
	require.Equal(t, 2, dataset.Report.UniqueDocuments)
	require.Equal(t, 1, dataset.Report.AvailableReactions)
	require.Equal(t, 1, dataset.Report.EmojiKeywords)
	require.Equal(t, 1, dataset.Report.FeaturedSets)
	require.Equal(t, int64(42), dataset.Featured.Sets[0].SourceID)
	require.Equal(t, int64(43), dataset.Featured.Sets[0].Covers[0].SourceID)
	require.Equal(t, 1, dataset.Report.StickerPreviews)
	require.Equal(t, 1, dataset.Report.ReactionPreviews)
	require.Equal(t, 2, dataset.Report.PathThumbnails)
	require.Zero(t, dataset.Report.MissingPreviews)
	require.Contains(t, dataset.Auxiliary, "featuredStickers.json")
}

func TestLoadReportsSourceContext(t *testing.T) {
	root := makeFixture(t)
	require.NoError(t, os.Remove(filepath.Join(root, "tgs", "sticker43")))

	_, err := Load(root)
	require.Error(t, err)
	require.Contains(t, err.Error(), "source document \"43\"")
	require.Contains(t, err.Error(), filepath.Join(root, "tgs", "sticker43"))
}

func TestLoadRejectsDuplicateNormalizedShortNameAndDocumentID(t *testing.T) {
	root := makeFixture(t)
	writeFile(t, filepath.Join(root, "json_data", "stickerSet-99.json"), `{
  "set":{"id":"99","accessHash":"8","title":"Duplicate","shortName":" TEST_PACK ","count":1},
  "stickers":[{"id":"43","stickerSetInfo":{"id":"99","accessHash":"8"},"emoji":"x","isLottie":true,"width":512,"height":512}]
}`)

	_, err := Load(root)
	require.Error(t, err)
	require.Contains(t, err.Error(), "duplicate normalized short name")
	require.Contains(t, err.Error(), "duplicate source document id")
}

func TestLoadCountsUnsupportedVideoWithoutRequiringAnAsset(t *testing.T) {
	root := makeFixture(t)
	setPath := filepath.Join(root, "json_data", "stickerSet-42.json")
	data, err := os.ReadFile(setPath)
	require.NoError(t, err)
	updated := strings.Replace(string(data), `"isLottie":true`, `"isLottie":false,"isVideo":true`, 1)
	writeFile(t, setPath, updated)
	require.NoError(t, os.Remove(filepath.Join(root, "tgs", "sticker43")))

	dataset, err := Load(root)
	require.NoError(t, err)
	require.Equal(t, 1, dataset.Report.UnsupportedVideos)
	require.Empty(t, dataset.Sets[0].Stickers[0].SourcePath)
}

func TestLoadAllowsMissingOptionalPreview(t *testing.T) {
	root := makeFixture(t)
	require.NoError(t, os.Remove(filepath.Join(root, "preview", "sticker43")))

	dataset, err := Load(root)
	require.NoError(t, err)
	require.Empty(t, dataset.Sets[0].Stickers[0].PreviewPath)
	require.Equal(t, 1, dataset.Report.MissingPreviews)
	require.Equal(t, 1, dataset.Report.ReactionPreviews)
}

func TestLoadRejectsMalformedPathThumbnail(t *testing.T) {
	root := makeFixture(t)
	setPath := filepath.Join(root, "json_data", "stickerSet-42.json")
	data, err := os.ReadFile(setPath)
	require.NoError(t, err)
	updated := strings.Replace(string(data), `M10,20z`, `not-a-telegram-path`, 1)
	writeFile(t, setPath, updated)

	_, err = Load(root)
	require.Error(t, err)
	require.Contains(t, err.Error(), "thumbnail path must start with M and end with z")
}

func TestLoadConfiguredDataset(t *testing.T) {
	root := os.Getenv("PWM_STICKER_DATA")
	if root == "" {
		t.Skip("PWM_STICKER_DATA is not set")
	}

	dataset, err := Load(root)
	require.NoError(t, err)
	require.NotEmpty(t, dataset.Version)
	require.NotEmpty(t, dataset.Sets)
	require.NotEmpty(t, dataset.Reactions)
	require.NotEmpty(t, dataset.EmojiKeywords.Keywords)
	require.Greater(t, dataset.Report.UniqueDocuments, 0)
}

func TestLoadRejectsSymlinkEscape(t *testing.T) {
	root := makeFixture(t)
	outside := filepath.Join(t.TempDir(), "outside")
	writeFile(t, outside, "tgs")
	asset := filepath.Join(root, "tgs", "sticker43")
	require.NoError(t, os.Remove(asset))
	require.NoError(t, os.Symlink(outside, asset))

	_, err := Load(root)
	require.Error(t, err)
	require.Contains(t, err.Error(), "resolves outside dataset root")
}

func TestLoadRejectsSymlinkedRoot(t *testing.T) {
	root := makeFixture(t)
	link := filepath.Join(t.TempDir(), "stickers")
	require.NoError(t, os.Symlink(root, link))

	_, err := Load(link)
	require.Error(t, err)
	require.Contains(t, err.Error(), "source root")
	require.Contains(t, err.Error(), "symlink")
}

func TestBuildFingerprintIsStableAndTracksPreviewBytes(t *testing.T) {
	root := makeFixture(t)
	dataset, err := Load(root)
	require.NoError(t, err)
	first, err := BuildFingerprint(dataset)
	require.NoError(t, err)
	second, err := BuildFingerprint(dataset)
	require.NoError(t, err)
	require.Equal(t, first.Dataset, second.Dataset)
	require.Contains(t, first.Files, filepath.Join(dataset.Root, "preview", "sticker43"))

	writeFile(t, filepath.Join(root, "preview", "sticker43"), "changed-preview")
	updated, err := Load(root)
	require.NoError(t, err)
	third, err := BuildFingerprint(updated)
	require.NoError(t, err)
	require.NotEqual(t, first.Dataset, third.Dataset)
}

func makeFixture(t *testing.T) string {
	t.Helper()
	root := t.TempDir()
	require.NoError(t, os.MkdirAll(filepath.Join(root, "json_data"), 0o755))
	require.NoError(t, os.MkdirAll(filepath.Join(root, "tgs"), 0o755))
	require.NoError(t, os.MkdirAll(filepath.Join(root, "preview"), 0o755))
	writeFile(t, filepath.Join(root, "version.txt"), "1.0.0\n")
	writeFile(t, filepath.Join(root, "json_data", "stickerSet-42.json"), `{
  "set":{"id":"42","accessHash":"-7","title":"Test Pack","shortName":"test_pack","count":1},
  "stickers":[{"id":"43","stickerSetInfo":{"id":"42","accessHash":"-7"},"emoji":"😀","isLottie":true,"width":512,"height":512,"thumbnail":{"dataUri":"data:image/svg+xml;utf8,<?xml version=\"1.0\" encoding=\"utf-8\"?><svg viewBox=\"0 0 512 512\"><path fill-opacity=\"0.1\" d=\"M10,20z\" /></svg>","width":512,"height":512},"isFree":true}]
}`)
	writeFile(t, filepath.Join(root, "json_data", "availableReactions.json"), `[
  {"reaction":{"emoticon":"👍"},"title":"Like","staticIcon":{"id":"51","size":3,"mimeType":"application/x-tgsticker","fileName":"AnimatedSticker.tgs","mediaSize":{"width":128,"height":128},"thumbnail":{"dataUri":"data:image/svg+xml;utf8,<?xml version=\"1.0\" encoding=\"utf-8\"?><svg viewBox=\"0 0 128 128\"><path fill-opacity=\"0.1\" d=\"M5-6z\" /></svg>","width":128,"height":128}}}
]`)
	writeFile(t, filepath.Join(root, "json_data", "emojiKeywords.json"), `{
  "language":"en","version":10,"keywords":{"happy":["😀"]}
}`)
	for _, name := range auxiliaryFiles {
		contents := `{}`
		if name == "featuredStickers.json" {
			contents = `{"hash":"1","isPremium":false,"sets":[{"id":"42","covers":[{"id":"43"}]}]}`
		}
		writeFile(t, filepath.Join(root, "json_data", name), contents)
	}
	writeFile(t, filepath.Join(root, "tgs", "sticker43"), "tgs")
	writeFile(t, filepath.Join(root, "tgs", "document51"), "tgs")
	writeFile(t, filepath.Join(root, "preview", "sticker43"), "webp")
	writeFile(t, filepath.Join(root, "preview", "document51"), "webp")
	return root
}

func writeFile(t *testing.T, path, contents string) {
	t.Helper()
	require.NoError(t, os.WriteFile(path, []byte(contents), 0o600))
}
