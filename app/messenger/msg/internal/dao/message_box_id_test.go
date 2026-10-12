package dao

import "testing"

func TestRepairMessageBoxSequenceAfterRedisRollback(t *testing.T) {
	var counter int32 = 45
	var repaired bool
	id, err := repairMessageBoxSequence(45, 109,
		func() int64 { return int64(counter) },
		func(value int32) { repaired = true; counter = value },
		func() int32 { counter++; return counter },
	)
	if err != nil || id != 110 || !repaired {
		t.Fatalf("expected first unused ID 110 after repair, got id=%d repaired=%v err=%v", id, repaired, err)
	}
}

func TestRepairMessageBoxSequenceDoesNotLowerConcurrentCounter(t *testing.T) {
	var repaired bool
	id, err := repairMessageBoxSequence(45, 109,
		func() int64 { return 120 },
		func(int32) { repaired = true },
		func() int32 { return 121 },
	)
	if err != nil || id != 121 || repaired {
		t.Fatalf("expected advanced counter to be kept, got id=%d repaired=%v err=%v", id, repaired, err)
	}
}

func TestRepairMessageBoxSequenceFailsClosed(t *testing.T) {
	_, err := repairMessageBoxSequence(45, 109,
		func() int64 { return 45 },
		func(int32) {},
		func() int32 { return 45 },
	)
	if err == nil {
		t.Fatal("expected an error instead of publishing an occupied message ID")
	}
}
