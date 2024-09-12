package service

import (
	"context"
	"github.com/teamgram/proto/mtproto"
	"google.golang.org/grpc/status"
	"mvdan.cc/xurls/v2"
)

func (s Service) MessagesGetWebPagePreview(
	ctx context.Context, preview *mtproto.TLMessagesGetWebPagePreview,
) (*mtproto.MessageMedia, error) {
	// Extract the URL from the message

	url := ""
	rIndexes := xurls.Relaxed().FindAllStringIndex(preview.Message, -1)
	if len(rIndexes) > 0 {
		url = preview.Message[rIndexes[0][0]:rIndexes[0][1]]
	}
	if url == "" {
		return nil, status.Error(mtproto.ErrBadRequest, "No URL found in message")
	}

	// Fetch web page preview
	webpage, err := s.svcCtx.Plugin.GetWebpagePreview(ctx, url)
	if err != nil {
		return nil, err
	}

	// Adjust messageMedia construction
	messageMedia := mtproto.MakeTLMessageMediaWebPage(
		&mtproto.MessageMedia{
			Webpage: webpage,
		},
	).To_MessageMedia()

	return messageMedia, nil
}

// Implementation of MessagesGetWebPage8D9692A3
func (s Service) MessagesGetWebPage8D9692A3(
	ctx context.Context, a3 *mtproto.TLMessagesGetWebPage8D9692A3,
) (*mtproto.Messages_WebPage, error) {
	// Fetch the web page using the provided URL
	if a3.Url == "" {
		return nil, status.Error(mtproto.ErrBadRequest, "Invalid URL")
	}
	webPage, err := s.svcCtx.Plugin.GetWebpagePreview(ctx, a3.Url)
	if err != nil {
		return nil, err
	}

	// Check if the hash matches (assuming we use the first byte of MD5 hash here)
	if a3.Hash != 0 && int32(webPage.Hash) == a3.Hash {
		// Return "not modified" if the hash matches
		webPage = mtproto.MakeTLWebPageNotModified(nil).To_WebPage()
	}
	// Return the full web page preview

	return mtproto.MakeTLMessagesWebPage(
		&mtproto.Messages_WebPage{
			Webpage: webPage,
		},
	).To_Messages_WebPage(), nil
}

func (s Service) MessagesGetWebPage32CA8F91(
	ctx context.Context, f91 *mtproto.TLMessagesGetWebPage32CA8F91,
) (*mtproto.WebPage, error) {
	// Step 1: Validate the input URL
	if f91.Url == "" {
		return nil, status.Error(mtproto.ErrBadRequest, "Invalid URL")
	}

	// Step 2: Fetch the web page content using the URL
	webPage, err := s.svcCtx.Plugin.GetWebpagePreview(ctx, f91.Url)
	if err != nil {
		return nil, err
	}

	// Step 3: Return the web page preview
	return webPage, nil
}
