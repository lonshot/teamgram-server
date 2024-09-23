package plugin

import (
	"bytes"
	"context"
	"crypto/md5"
	"crypto/tls"
	"fmt"
	"golang.org/x/net/html"
	"time"

	"github.com/teamgram/marmota/pkg/net/rpcx"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/zrpc"
	"google.golang.org/protobuf/types/known/wrapperspb"
	"image"
	"io/ioutil"
	"net/http"
	"pwm-server/app/service/media/media"
	"strings"

	"github.com/teamgram/proto/mtproto"
	media_client "pwm-server/app/service/media/client"
)

type MessagesPlugin interface {
	GetWebpagePreview(ctx context.Context, url string) (*mtproto.WebPage, error)
	GetMessageMedia(ctx context.Context, userId, ownerId int64, media *mtproto.InputMedia) (
		*mtproto.MessageMedia, error,
	)
	// RebuildMessageEntities(ctx context.Context, fromId int64, peer *mtproto.PeerUtil, noWebpage bool, message *mtproto.Message, hasBot bool) (*mtproto.Message, error)
}

type defaultMessagesPlugin struct {
	media_client.MediaClient
}

func NewMessagesPlugin(mediaClientConfig zrpc.RpcClientConf) MessagesPlugin {
	return &defaultMessagesPlugin{
		MediaClient: media_client.NewMediaClient(rpcx.GetCachedRpcClient(mediaClientConfig)),
	}
}

func (d defaultMessagesPlugin) GetWebpagePreview(ctx context.Context, url string) (*mtproto.WebPage, error) {
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true}, // Consider using secure verification in production
	}
	client := &http.Client{
		Transport: tr,
		Timeout:   10 * time.Second,
	}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %v", err)
	}
	// Set User-Agent to mimic Chrome
	req.Header.Set(
		"User-Agent",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36",
	)

	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch web page: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("failed to fetch web page, status code: %d", resp.StatusCode)
	}

	// Read the content of the web page
	bodyBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read web page content: %v", err)
	}

	// Calculate the hash of the content
	hash := md5.Sum(bodyBytes)
	contentHash := int32(hash[0]) // Adjust hash calculation if needed

	// Parse the HTML content using net/html
	doc, err := html.Parse(bytes.NewReader(bodyBytes))
	if err != nil {
		return nil, fmt.Errorf("failed to parse web page content: %v", err)
	}

	// Extract metadata
	var title, description, image, siteName string
	var extractMeta func(*html.Node)

	// Function to traverse the HTML tree and extract meta tags
	extractMeta = func(n *html.Node) {
		if n.Type == html.ElementNode {
			switch n.Data {
			case "title":
				if n.FirstChild != nil {
					title = n.FirstChild.Data
				}
			case "meta":
				var nameAttr, contentAttr string
				for _, attr := range n.Attr {
					if attr.Key == "name" || attr.Key == "property" {
						nameAttr = attr.Val
					}
					if attr.Key == "content" {
						contentAttr = attr.Val
					}
				}

				// Only assign if nameAttr and contentAttr are not empty
				if nameAttr != "" && contentAttr != "" {
					switch nameAttr {
					case "description", "og:description":
						description = contentAttr
					case "og:image":
						image = contentAttr
					case "og:site_name":
						siteName = contentAttr
					}
				}
			}
		}

		// Recursively traverse the child nodes
		for c := n.FirstChild; c != nil; c = c.NextSibling {
			extractMeta(c)
		}
	}

	// Start parsing the HTML tree
	extractMeta(doc)

	// Use title as a fallback for site name
	if siteName == "" {
		siteName = title
	}

	// Simplify the URL for display purposes
	displayUrl := d.getDisplayUrl(url)

	// Convert image to photo if available
	var photo *mtproto.Photo
	if image != "" {
		photo, err = d.convertImageToPhoto(ctx, image)
		if err != nil {
			logx.Errorf("fetchWebPage - error converting image to photo: %v", err)
		}
	}

	// Create and return a WebPage object with extracted metadata
	return mtproto.MakeTLWebPage(
		&mtproto.WebPage{
			Url_STRING:  url,
			DisplayUrl:  displayUrl,
			Hash:        contentHash,
			Title:       wrapperspb.String(title),
			Description: wrapperspb.String(description),
			Photo:       photo,
			SiteName:    wrapperspb.String(siteName),
			Type:        wrapperspb.String("article"),
		},
	).To_WebPage(), nil
}

func (d defaultMessagesPlugin) GetMessageMedia(
	ctx context.Context, userId, ownerId int64, media *mtproto.InputMedia,
) (*mtproto.MessageMedia, error) {
	//TODO implement me
	panic("implement me")
}

// Generate a display URL (strip protocol from the URL)
func (d defaultMessagesPlugin) getDisplayUrl(url string) string {
	return strings.TrimPrefix(strings.TrimPrefix(url, "https://"), "http://")
}

// Convert an image URL to a Photo structure using MediaClient
func (d defaultMessagesPlugin) convertImageToPhoto(ctx context.Context, imageUrl string) (*mtproto.Photo, error) {
	var (
		mediaInput   *mtproto.InputMedia
		messageMedia *mtproto.MessageMedia
		document     *mtproto.Document
		err          error
	)

	// Step 1: Fetch metadata from the image URL
	width, height, size, mimeType, err := d.fetchImageMetadata(imageUrl)
	if err != nil {
		logx.Errorf("convertImageToPhoto - error fetching image metadata: %v", err)
		return nil, err
	}

	// Step 2: Use MediaClient to upload the image and get the MessageMedia
	mediaInput = &mtproto.InputMedia{
		MimeType: mimeType, // Set the appropriate mime type for the image (adjust if necessary)
		Url:      imageUrl, // Use the image URL for fetching the image
	}

	// Call MediaUploadedDocumentMedia from MediaClient to upload the image and get MessageMedia
	messageMedia, err = d.MediaClient.MediaUploadedDocumentMedia(
		ctx, &media.TLMediaUploadedDocumentMedia{
			OwnerId: 0, // Use the appropriate owner ID if available
			Media:   mediaInput,
		},
	)
	if err != nil {
		logx.Errorf("convertImageToPhoto - error uploading image using MediaClient: %v", err)
		return nil, err
	}

	// Extract the document from the MessageMedia
	document = messageMedia.GetDocument()
	if document == nil {
		logx.Errorf("convertImageToPhoto - no document found in MessageMedia")
		return nil, err
	}

	// Step 3: Create a PhotoSize object based on the image metadata
	photoSize := mtproto.MakeTLPhotoSize(
		&mtproto.PhotoSize{
			Type:  "m",                    // 'm' for medium size (adjust as necessary)
			W:     width,                  // Set the width of the image
			H:     height,                 // Set the height of the image
			Size2: size,                   // Set the size of the image in bytes
			Bytes: nil,                    // Assuming no byte data available for this, set to nil
			Sizes: []int32{width, height}, // Optional field with size information
		},
	).To_PhotoSize()

	// Step 4: Create and return the Photo object with the PhotoSize
	return mtproto.MakeTLPhoto(
		&mtproto.Photo{
			Id:            document.GetId(),                // Use the document ID returned by MediaClient
			HasStickers:   false,                           // Set accordingly
			AccessHash:    document.GetAccessHash(),        // Set access hash from document
			FileReference: document.GetFileReference(),     // Set file reference if applicable
			Date:          int32(0),                        // Set the date if available (e.g., current timestamp)
			Sizes:         []*mtproto.PhotoSize{photoSize}, // Assign the created PhotoSize object
			DcId:          document.GetDcId(),              // Set the DC ID if available
		},
	).To_Photo(), nil
}

// Function to fetch image metadata (width, height, size, and MIME type) from the URL
func (d defaultMessagesPlugin) fetchImageMetadata(imageUrl string) (
	int32, int32, int32, string, error,
) {
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true}, // Use secure verification in production
	}
	client := &http.Client{
		Transport: tr,
		Timeout:   10 * time.Second,
	}

	fmt.Printf("Fetching image metadata from URL: %s\n", imageUrl)

	req, err := http.NewRequest("GET", imageUrl, nil)
	if err != nil {
		return 0, 0, 0, "", fmt.Errorf("failed to create request: %v", err)
	}
	// Set User-Agent to mimic Chrome
	req.Header.Set(
		"User-Agent",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36",
	)

	// Fetch the image data
	resp, err := client.Do(req)
	if err != nil {
		return 0, 0, 0, "", fmt.Errorf("failed to fetch image: %v", err)
	}
	defer resp.Body.Close()

	// Check for a successful response
	if resp.StatusCode != http.StatusOK {
		return 0, 0, 0, "", fmt.Errorf("failed to fetch image, status code: %d", resp.StatusCode)
	}
	fmt.Printf("Received response with status code: %d\n", resp.StatusCode)

	// Get the MIME type from the Content-Type header
	mimeType := resp.Header.Get("Content-Type")
	if mimeType == "" {
		return 0, 0, 0, "", fmt.Errorf("unable to get MIME type")
	}
	fmt.Printf("MIME type: %s\n", mimeType)

	// Read the response body to check its content
	bodyBytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return 0, 0, 0, "", fmt.Errorf("failed to read response body: %v", err)
	}
	fmt.Printf("Read %d bytes from response body\n", len(bodyBytes))

	// Decode the image to get its dimensions
	img, _, err := image.DecodeConfig(bytes.NewReader(bodyBytes))
	if err != nil {
		return 0, 0, 0, "", fmt.Errorf("failed to decode image: %v; MIME type: %s", err, mimeType)
	}

	// Get content length from headers for size
	size := int32(len(bodyBytes))
	if size <= 0 {
		return 0, 0, 0, "", fmt.Errorf("unable to get image size")
	}
	fmt.Printf("Image dimensions: %d x %d, Size: %d bytes\n", img.Width, img.Height, size)

	return int32(img.Width), int32(img.Height), size, mimeType, nil
}
