package core

import (
	"pwm-server/app/interface/session/session"
)

// SessionSendHttpDataToSession
// session.sendHttpDataToSession client:SessionClientData = HttpSessionData;
func (c *SessionCore) SessionSendHttpDataToSession(in *session.TLSessionSendHttpDataToSession) (*session.HttpSessionData, error) {
	//var (
	//	data = in.GetClient()
	//)
	//
	//if data == nil {
	//	err := mtproto.ErrInputRequestInvalid
	//	c.Logger.Errorf("session.sendHttpDataToSession - error: %v", err)
	//	return nil, err
	//}
	//
	//mainAuth, err := c.getOrFetchMainAuthWrapper(data.PermAuthKeyId)
	//if err != nil {
	//	c.Logger.Errorf("session.sendHttpDataToSession - error: %v", err)
	//	return nil, err
	//}
	//
	//chData := make(chan interface{})
	//mainAuth.SessionHttpDataArrived(
	//	c.ctx,
	//	int(data.KeyType),
	//	data.AuthKeyId,
	//	data.ServerId,
	//	data.ClientIp,
	//	data.SessionId,
	//	data.Salt,
	//	data.Payload,
	//	chData)
	//
	//timer := time.NewTimer(time.Second * 7)
	//select {
	//case cData := <-chData:
	//	return &session.HttpSessionData{
	//		Payload: cData.([]byte),
	//	}, nil
	//case <-timer.C:
	//	c.Logger.Errorf("chData timeout...")
	//}

	c.Logger.Errorf("session.sendHttpDataToSession - error: not implement")

	return &session.HttpSessionData{
		Payload: []byte{},
	}, nil
}
