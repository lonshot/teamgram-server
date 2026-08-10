package dao

import (
	"database/sql"
	"errors"
	"testing"

	"github.com/stretchr/testify/require"
)

type stickerCatalogTxStub struct {
	markerInserted bool
	defaultInserts int
	queries        []string
}

func (s *stickerCatalogTxStub) Exec(query string, _ ...interface{}) (sql.Result, error) {
	s.queries = append(s.queries, query)
	if len(s.queries) == 1 || len(s.queries) == 3 {
		if s.markerInserted {
			return stickerCatalogResult(0), nil
		}
		s.markerInserted = true
		return stickerCatalogResult(1), nil
	}
	s.defaultInserts++
	return stickerCatalogResult(2), nil
}

type stickerCatalogResult int64

func (stickerCatalogResult) LastInsertId() (int64, error) { return 0, errors.New("unsupported") }
func (r stickerCatalogResult) RowsAffected() (int64, error) {
	return int64(r), nil
}

func TestInitializeUserStickerCatalogIsIdempotent(t *testing.T) {
	tx := new(stickerCatalogTxStub)
	require.NoError(t, initializeUserStickerCatalogTx(tx, 42, 1))
	require.NoError(t, initializeUserStickerCatalogTx(tx, 42, 1))
	require.Equal(t, 1, tx.defaultInserts)
	require.Len(t, tx.queries, 3)
}

func TestInitializeUserStickerCatalogCategoryPredicates(t *testing.T) {
	for _, category := range []uint8{1, 2, 3} {
		tx := new(stickerCatalogTxStub)
		require.NoError(t, initializeUserStickerCatalogTx(tx, 42, category))
		require.Contains(t, tx.queries[1], "masks = 0 AND emojis = 0")
		require.Contains(t, tx.queries[1], "masks = 1 AND emojis = 0")
		require.Contains(t, tx.queries[1], "emojis = 1")
		require.Contains(t, tx.queries[1], "ORDER BY display_order, id")
	}
}
