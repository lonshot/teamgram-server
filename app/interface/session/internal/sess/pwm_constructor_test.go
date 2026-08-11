package sess

import (
	"testing"

	"github.com/teamgram/proto/mtproto"
)

func TestNativePwmConstructorsAreRegisteredInSessionBinary(t *testing.T) {
	tests := []struct {
		name    string
		classID int32
	}{
		{name: "pwm.getPartners", classID: -1984457993},
		{name: "pwm.getTask", classID: -1847994758},
		{name: "pwm.submitAnswer", classID: -1738649032},
		{name: "pwm.getDifference", classID: 641129150},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if object := mtproto.NewTLObjectByClassID(test.classID); object == nil {
				t.Fatalf("constructor %s (%08x) is missing from the session MTProto registry", test.name, uint32(test.classID))
			}
		})
	}
}
