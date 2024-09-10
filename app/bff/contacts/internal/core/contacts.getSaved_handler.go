package core

import (
	"github.com/teamgram/proto/mtproto"
)

// ContactsGetSaved
// contacts.getSaved#82f1e39f = Vector<SavedContact>;
func (c *ContactsCore) ContactsGetSaved(in *mtproto.TLContactsGetSaved) (*mtproto.Vector_SavedContact, error) {
	// TODO: not impl

	return &mtproto.Vector_SavedContact{
		Datas: []*mtproto.SavedContact{},
	}, nil
}
