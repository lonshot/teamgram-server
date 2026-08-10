package main

import (
	"bytes"
	"encoding/json"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestRunRejectsInvalidWorkerCountBeforeReadingSource(t *testing.T) {
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	err := run([]string{"-workers", "0", "-dry-run"}, &stdout, &stderr)
	require.EqualError(t, err, "-workers must be greater than zero")
	require.Empty(t, stdout.String())
}

func TestRunNativeExecutionRequiresAReadableConfig(t *testing.T) {
	root := fixturePath(t)
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	err := run([]string{"-source", root, "-config", filepath.Join(root, "missing.yaml")}, &stdout, &stderr)
	require.Error(t, err)
	require.Contains(t, err.Error(), "load native importer config")
}

func TestRunDryRunReportsValidatedDataset(t *testing.T) {
	root := fixturePath(t)
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	require.NoError(t, run([]string{"-source", root, "-dry-run", "-workers", "2", "-set-id", "42"}, &stdout, &stderr))

	var result dryRunResult
	require.NoError(t, json.Unmarshal(stdout.Bytes(), &result))
	require.Equal(t, "1.0.0", result.Version)
	require.Len(t, result.Checksum, 64)
	require.Equal(t, 2, result.Workers)
	require.Equal(t, 1, result.SelectedSets)
	require.Equal(t, 1, result.Report.StickerSets)
}

func fixturePath(t *testing.T) string {
	t.Helper()
	path, err := filepath.Abs(filepath.Join("testdata", "dataset"))
	require.NoError(t, err)
	return path
}
