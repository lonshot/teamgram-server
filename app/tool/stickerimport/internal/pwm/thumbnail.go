package pwm

import (
	"fmt"
	"strconv"
	"strings"
)

const (
	thumbnailDataURIPrefix = "data:image/svg+xml;utf8,"
	pathLookup             = "AACAAAAHAAALMAAAQASTAVAAAZaacaaaahaaalmaaaqastava.az0123456789-,"
)

// pathBytesFromThumbnail restores a valid Telegram PhotoPathSize byte stream
// from the SVG produced by teamgram-tt's pathBytesToSvg. The compressed stream
// is not necessarily byte-identical to the upstream stream, but decoding it
// with the Telegram algorithm is guaranteed to reproduce the exact SVG path.
func pathBytesFromThumbnail(thumbnail *Thumbnail, expectedWidth, expectedHeight int32) error {
	if thumbnail == nil {
		return nil
	}
	if thumbnail.Width != expectedWidth || thumbnail.Height != expectedHeight {
		return fmt.Errorf("thumbnail dimensions %dx%d do not match document %dx%d", thumbnail.Width, thumbnail.Height, expectedWidth, expectedHeight)
	}
	if !strings.HasPrefix(thumbnail.DataURI, thumbnailDataURIPrefix) {
		return fmt.Errorf("thumbnail is not an inline SVG data URI")
	}
	svg := strings.TrimPrefix(thumbnail.DataURI, thumbnailDataURIPrefix)
	if !strings.Contains(svg, fmt.Sprintf(`viewBox="0 0 %d %d"`, expectedWidth, expectedHeight)) {
		return fmt.Errorf("thumbnail SVG viewBox does not match document %dx%d", expectedWidth, expectedHeight)
	}
	const marker = `<path fill-opacity="0.1" d="`
	start := strings.Index(svg, marker)
	if start < 0 {
		return fmt.Errorf("thumbnail SVG has no Telegram path marker")
	}
	start += len(marker)
	end := strings.IndexByte(svg[start:], '"')
	if end < 0 {
		return fmt.Errorf("thumbnail SVG path is unterminated")
	}
	path := svg[start : start+end]
	bytes, err := encodePathBytes(path)
	if err != nil {
		return err
	}
	if decoded := decodePathBytes(bytes); decoded != path {
		return fmt.Errorf("thumbnail path round-trip mismatch")
	}
	thumbnail.PathBytes = bytes
	return nil
}

func encodePathBytes(path string) ([]byte, error) {
	if len(path) < 2 || path[0] != 'M' || path[len(path)-1] != 'z' {
		return nil, fmt.Errorf("thumbnail path must start with M and end with z")
	}
	payload := path[1 : len(path)-1]
	result := make([]byte, 0, len(payload))
	for index := 0; index < len(payload); {
		if payload[index] >= '0' && payload[index] <= '9' {
			length := 1
			if payload[index] != '0' && index+1 < len(payload) && payload[index+1] >= '0' && payload[index+1] <= '9' {
				value, _ := strconv.Atoi(payload[index : index+2])
				if value <= 63 {
					length = 2
				}
			}
			value, _ := strconv.Atoi(payload[index : index+length])
			result = append(result, byte(value))
			index += length
			continue
		}

		lookupIndex := strings.IndexByte(pathLookup, payload[index])
		if lookupIndex < 0 {
			return nil, fmt.Errorf("thumbnail path contains unsupported byte %q", payload[index])
		}
		result = append(result, byte(192+lookupIndex))
		index++
	}
	return result, nil
}

func decodePathBytes(bytes []byte) string {
	var result strings.Builder
	result.WriteByte('M')
	for _, value := range bytes {
		switch {
		case value >= 192:
			result.WriteByte(pathLookup[value-192])
		case value >= 128:
			result.WriteByte(',')
			result.WriteString(strconv.Itoa(int(value & 63)))
		case value >= 64:
			result.WriteByte('-')
			result.WriteString(strconv.Itoa(int(value & 63)))
		default:
			result.WriteString(strconv.Itoa(int(value)))
		}
	}
	result.WriteByte('z')
	return result.String()
}
