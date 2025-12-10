package core

import (
	"context"
	"fmt"
	"github.com/teamgram/proto/mtproto"
	media "pwm-server/app/service/media/media"
)

// MessagesGetDocumentByHash
// messages.getDocumentByHash#338e2464 sha256:bytes size:int mime_type:string = Document;
func (c *FilesCore) MessagesGetDocumentByHash(in *mtproto.TLMessagesGetDocumentByHash) (*mtproto.Document, error) {
	// Retrieve size (either int64 or int32)
	var size int64
	if in.Size2_INT64 > 0 {
		size = in.Size2_INT64
	} else if in.Size2_INT32 > 0 {
		size = int64(in.Size2_INT32)
	} else {
		err := fmt.Errorf("invalid input: size is missing or zero")
		c.Logger.Errorf("MessagesGetDocumentByHash - error: %v", err)
		return nil, err
	}

	// Validate input
	if len(in.Sha256) == 0 || in.MimeType == "" {
		err := fmt.Errorf("invalid input: sha256 is empty or mime_type is missing")
		c.Logger.Errorf("MessagesGetDocumentByHash - error: %v", err)
		return nil, err
	}

	// First, find the document ID based on the sha256, size, and mime type
	documentId, err := c.findDocumentIdByHash(c.ctx, in.Sha256, size, in.MimeType)
	if err != nil {
		c.Logger.Errorf("MessagesGetDocumentByHash - error finding document ID by hash: %v", err)
		return mtproto.MakeTLDocumentEmpty(nil).To_Document(), nil
	}

	// Now, fetch the document using the ID with MediaClient
	document, err := c.fetchDocumentById(c.ctx, documentId)
	if err != nil {
		c.Logger.Errorf("MessagesGetDocumentByHash - error fetching document by ID: %v", err)
		return mtproto.MakeTLDocumentEmpty(nil).To_Document(), nil
	}

	// Return the found document
	return document, nil
}

// findDocumentIdByHash simulates finding a document's ID by its hash, size, and MIME type
// You would typically use your database or storage indexing system to perform this lookup
func (c *FilesCore) findDocumentIdByHash(ctx context.Context, sha256 []byte, size int64, mimeType string) (int64, error) {
	// Simulate a document ID lookup based on sha256, size, and mime type
	// This should be replaced with actual logic that queries your document store or database

	// Example: Return a document ID (this would come from your storage or database)
	documentId := int64(123456) // Simulate a document ID found via a lookup
	return documentId, nil
}

// fetchDocumentById uses MediaClient to fetch a document by its ID
func (c *FilesCore) fetchDocumentById(ctx context.Context, documentId int64) (*mtproto.Document, error) {
	// Use the MediaClient to fetch the document by ID
	doc, err := c.svcCtx.MediaClient.MediaGetDocument(ctx, &media.TLMediaGetDocument{
		Id: documentId,
	})
	if err != nil {
		return nil, fmt.Errorf("failed to fetch document by ID: %w", err)
	}

	// Return the document if found
	return doc, nil
}
