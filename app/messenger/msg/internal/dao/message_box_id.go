package dao

import (
	"context"
	"fmt"
)

// A restored ID generator can lag behind rows that are still reserved in SQL,
// including soft-deleted messages. Repair it before publishing a message ID.
func (d *Dao) reserveMessageBoxId(ctx context.Context, userId int64, candidate int32) (int32, error) {
	maxId, err := d.MessagesDAO.MaxUserMessageBoxId(ctx, userId)
	if err != nil {
		return 0, err
	}
	return repairMessageBoxSequence(candidate, maxId,
		func() int64 { return d.IDGenClient2.CurrentMessageBoxId(ctx, userId) },
		func(id int32) { d.IDGenClient2.SetCurrentMessageBoxId(ctx, userId, id) },
		func() int32 { return d.IDGenClient2.NextMessageBoxId(ctx, userId) },
	)
}

func repairMessageBoxSequence(candidate, maxId int32, current func() int64, set func(int32), next func() int32) (int32, error) {
	if candidate > maxId {
		return candidate, nil
	}

	// Recheck the generator before setting it, because another request may
	// already have advanced it. A collision in the insert is still rejected.
	if current() <= int64(maxId) {
		set(maxId)
	}
	for attempt := 0; attempt < 3; attempt++ {
		candidate = next()
		if candidate > maxId {
			return candidate, nil
		}
	}
	return 0, fmt.Errorf("message box sequence did not advance beyond %d", maxId)
}
