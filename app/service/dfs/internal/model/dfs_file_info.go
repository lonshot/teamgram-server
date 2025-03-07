package model

import (
	"fmt"
	"io"
	"strconv"
	"time"
)

var (
	ErrorDfsFileNotFound = fmt.Errorf("dfs file not found")
)

type DfsFileInfo struct {
	Creator           int64  `json:"creator"`
	FileId            int64  `json:"file_id"`
	Big               bool   `json:"big"`
	FileName          string `json:"file_name"`
	FileTotalParts    int    `json:"file_total_parts"`
	FirstFilePartSize int    `json:"first_file_part_size"`
	FilePartSize      int    `json:"file_part_size"`
	LastFilePartSize  int    `json:"last_file_part_size"`
	MimeType          string `json:"mime_type"`
	Mtime             int64  `json:"mtime"`
}

func (m *DfsFileInfo) ToArgs() map[string]string {
	values := make(map[string]string, 7)
	if m.Big {
		values["big"] = "true"
	}
	if m.FileName != "" {
		values["file_name"] = m.FileName
	}
	if m.FileTotalParts > 0 {
		values["file_total_parts"] = strconv.Itoa(m.FileTotalParts)
	}
	if m.FirstFilePartSize > 0 {
		values["first_file_part_size"] = strconv.Itoa(m.FirstFilePartSize)
	}
	if m.FilePartSize > 0 {
		values["file_part_size"] = strconv.Itoa(m.FilePartSize)
	}
	if m.LastFilePartSize > 0 {
		values["last_file_part_size"] = strconv.Itoa(m.LastFilePartSize)
	}
	if m.Mtime > 0 {
		values["mtime"] = strconv.Itoa(int(m.Mtime))
	}
	return values
}

func (m *DfsFileInfo) GetFileSize() int64 {
	if m.FileTotalParts <= 0 {
		return 0
	} else if m.FileTotalParts == 1 {
		return int64(m.FirstFilePartSize)
	} else if m.FileTotalParts == 2 {
		return int64(m.FirstFilePartSize + m.FilePartSize)
	} else {
		return int64(m.FirstFilePartSize + (m.FileTotalParts-2)*m.FilePartSize + m.LastFilePartSize)
	}
}

type DfsHttpFileInfo struct {
	io.ReadSeeker
	Name    string
	Modtime time.Time
}
