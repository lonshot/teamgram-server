package dao

import (
	"bytes"
	"context"
	"crypto/md5"
	"crypto/tls"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
	"time"

	"pwm-server/app/service/biz/username/username"

	"github.com/teamgram/proto/mtproto"
	"golang.org/x/net/html"
	"google.golang.org/protobuf/types/known/wrapperspb"
)

func (d *Dao) ReadReactionUnreadMessage(ctx context.Context, userId int64, msgId int32) error {
	return mtproto.ErrMethodNotImpl
}

func (d *Dao) UsernameResolveUsername(ctx context.Context, in *username.TLUsernameResolveUsername) (*mtproto.Peer, error) {
	return d.UsernameClient.UsernameResolveUsername(ctx, in)
}

func (d *Dao) GetWebpagePreview(ctx context.Context, url string) (*mtproto.WebPage, error) {
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
	var title, description, siteName string
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
					//case "og:image":
					//	image = contentAttr
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
	//var photo *mtproto.Photo
	//if image != "" {
	//	photo, err = d.convertImageToPhoto(ctx, image)
	//	if err != nil {
	//		logx.Errorf("fetchWebPage - error converting image to photo: %v", err)
	//	}
	//}

	// Create and return a WebPage object with extracted metadata
	return mtproto.MakeTLWebPage(
		&mtproto.WebPage{
			Url_STRING:  url,
			DisplayUrl:  displayUrl,
			Hash:        contentHash,
			Title:       wrapperspb.String(title),
			Description: wrapperspb.String(description),
			//Photo:       photo,
			SiteName: wrapperspb.String(siteName),
			Type:     wrapperspb.String("article"),
		},
	).To_WebPage(), nil
}

// Generate a display URL (strip protocol from the URL)
func (d *Dao) getDisplayUrl(url string) string {
	return strings.TrimPrefix(strings.TrimPrefix(url, "https://"), "http://")
}

// // Convert an image URL to a Photo structure using MediaClient
// func (d *Dao) convertImageToPhoto(ctx context.Context, imageUrl string) (*mtproto.Photo, error) {
//     var (
//         mediaInput   *mtproto.InputMedia
//         messageMedia *mtproto.MessageMedia
//         document     *mtproto.Document
//         err          error
//     )

//     // Log the image URL being processed
//     logx.Infof("convertImageToPhoto: Processing image URL: %s", imageUrl)

//     // Step 1: Fetch metadata from the image URL
//     width, height, size, mimeType, err := d.fetchImageMetadata(imageUrl)
//     if err != nil {
//         logx.Errorf("convertImageToPhoto: Error fetching image metadata: %v", err)
//         return nil, err
//     }

//     // Log the fetched metadata for debugging
//     logx.Infof("convertImageToPhoto: Image metadata - Width: %d, Height: %d, Size: %d bytes, MIME Type: %s", width, height, size, mimeType)

//     // Step 2: Prepare InputMedia for MediaClient
//     mediaInput = &mtproto.InputMedia{
//         MimeType: mimeType, // Use the fetched MIME type
//         Url:      imageUrl, // Set the image URL for fetching
//     }

//     // Step 3: Call MediaUploadedDocumentMedia to upload the image and get MessageMedia
//     messageMedia, err = d.MediaClient.MediaUploadedDocumentMedia(
//         ctx, &media.TLMediaUploadedDocumentMedia{
//             OwnerId: 0, // Use the appropriate owner ID (e.g., current user ID)
//             Media:   mediaInput,
//         },
//     )
//     if err != nil {
//         logx.Errorf("convertImageToPhoto: Error uploading image using MediaClient: %v", err)
//         return nil, err
//     }

//     // Extract the document from the MessageMedia
//     document = messageMedia.GetDocument()
//     if document == nil {
//         logx.Errorf("convertImageToPhoto: No document found in MessageMedia")
//         return nil, fmt.Errorf("document not found in MessageMedia")
//     }

//     // Step 4: Create a PhotoSize object based on the fetched metadata
//     photoSize := mtproto.MakeTLPhotoSize(
//         &mtproto.PhotoSize{
//             Type:  "m",      // 'm' for medium size (adjust if needed)
//             W:     width,    // Set the image width
//             H:     height,   // Set the image height
//             Size2: size,     // Set the image size in bytes
//         },
//     ).To_PhotoSize()

//     // Step 5: Construct and return the Photo object
//     photo := mtproto.MakeTLPhoto(
//         &mtproto.Photo{
//             Id:            document.GetId(),                // Use document ID
//             HasStickers:   false,                           // Set accordingly (e.g., if image has stickers)
//             AccessHash:    document.GetAccessHash(),        // Access hash from document
//             FileReference: document.GetFileReference(),     // File reference from document
//             Date:          int32(time.Now().Unix()),        // Set the current timestamp
//             Sizes:         []*mtproto.PhotoSize{photoSize}, // Include the created PhotoSize object
//             DcId:          document.GetDcId(),              // Data Center ID from document
//         },
//     ).To_Photo()

//     // Log successful conversion
//     logx.Infof("convertImageToPhoto: Successfully converted image to Photo structure. Photo ID: %d", photo.GetId())

//     return photo, nil
// }

// func (d *Dao) fetchImageMetadata(imageUrl string) (
// 	int32, int32, int32, string, error,
// ) {
// 	tr := &http.Transport{
// 		TLSClientConfig: &tls.Config{InsecureSkipVerify: true}, // Use secure verification in production
// 	}
// 	client := &http.Client{
// 		Transport: tr,
// 		Timeout:   10 * time.Second,
// 	}

// 	fmt.Printf("Fetching image metadata from URL: %s\n", imageUrl)

// 	req, err := http.NewRequest("GET", imageUrl, nil)
// 	if err != nil {
// 		return 0, 0, 0, "", fmt.Errorf("failed to create request for %s: %v", imageUrl, err)
// 	}
// 	req.Header.Set(
// 		"User-Agent",
// 		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36",
// 	)

// 	resp, err := client.Do(req)
// 	if err != nil {
// 		return 0, 0, 0, "", fmt.Errorf("failed to fetch image from %s: %v", imageUrl, err)
// 	}
// 	defer resp.Body.Close()

// 	if resp.StatusCode != http.StatusOK {
// 		return 0, 0, 0, "", fmt.Errorf("failed to fetch image from %s, status code: %d", imageUrl, resp.StatusCode)
// 	}
// 	fmt.Printf("Received response with status code: %d\n", resp.StatusCode)

// 	// Read and decode the image directly
// 	img, err := imaging.Decode(resp.Body) // Stream directly from the response
// 	if err != nil {
// 		return 0, 0, 0, "", fmt.Errorf("failed to decode image from %s: %v", imageUrl, err)
// 	}

// 	width := int32(img.Bounds().Max.X)
// 	height := int32(img.Bounds().Max.Y)
// 	size := int32(resp.ContentLength) // Use Content-Length if available
// 	mimeType := resp.Header.Get("Content-Type")

// 	fmt.Printf("Image dimensions: %d x %d, Size: %d bytes\n", width, height, size)
// 	fmt.Printf("Guessed MIME type: %s\n", mimeType)

// 	return width, height, size, mimeType, nil
// }
