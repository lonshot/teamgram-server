package service

import (
	"context"

	"github.com/zeromicro/go-zero/core/logx"

	"pwm-server/app/service/status/internal/core"
	"pwm-server/app/service/status/status"

	"github.com/teamgram/proto/mtproto"
)

// StatusSetSessionOnline
// status.setSessionOnline user_id:long session:SessionEntry = Bool;
func (s *Service) StatusSetSessionOnline(ctx context.Context, request *status.TLStatusSetSessionOnline) (*mtproto.Bool, error) {
	c := core.New(ctx, s.svcCtx)
	c.Logger.Debugf("status.setSessionOnline - metadata: %s, request: %s", c.MD, request)

	r, err := c.StatusSetSessionOnline(request)
	if err != nil {
		return nil, err
	}

	c.Logger.Debugf("status.setSessionOnline - reply: %s", r)
	return r, err
}

// StatusSetSessionOffline
// status.setSessionOffline user_id:long auth_key_id:long = Bool;
func (s *Service) StatusSetSessionOffline(ctx context.Context, request *status.TLStatusSetSessionOffline) (*mtproto.Bool, error) {
	c := core.New(ctx, s.svcCtx)
	c.Logger.Debugf("status.setSessionOffline - metadata: %s, request: %s", c.MD, request)

	r, err := c.StatusSetSessionOffline(request)
	if err != nil {
		return nil, err
	}

	c.Logger.Debugf("status.setSessionOffline - reply: %s", r)
	return r, err
}

// StatusGetUserOnlineSessions
// status.getUserOnlineSessions user_id:long = UserSessionEntryList;
func (s *Service) StatusGetUserOnlineSessions(ctx context.Context, request *status.TLStatusGetUserOnlineSessions) (*status.UserSessionEntryList, error) {
	c := core.New(ctx, s.svcCtx)
	c.Logger.Debugf("status.getUserOnlineSessions - metadata: %s, request: %s", c.MD, request)

	r, err := c.StatusGetUserOnlineSessions(request)
	if err != nil {
		return nil, err
	}

	c.Logger.Debugf("status.getUserOnlineSessions - reply: %s", r)
	return r, err
}

// StatusGetUsersOnlineSessionsList
// status.getUsersOnlineSessionsList users:Vector<long> = Vector<UserSessionEntryList>;
func (s *Service) StatusGetUsersOnlineSessionsList(ctx context.Context, request *status.TLStatusGetUsersOnlineSessionsList) (*status.Vector_UserSessionEntryList, error) {
	c := core.New(ctx, s.svcCtx)
	c.Logger.Debugf("status.getUsersOnlineSessionsList - metadata: %s, request: %s", c.MD, request)

	r, err := c.StatusGetUsersOnlineSessionsList(request)
	if err != nil {
		return nil, err
	}

	c.Logger.Debugf("status.getUsersOnlineSessionsList - reply: %s", r)
	return r, err
}

// StatusGetChannelOnlineUsers
// status.getChannelOnlineUsers channel_id:long = Vector<long>;
func (s *Service) StatusGetChannelOnlineUsers(ctx context.Context, request *status.TLStatusGetChannelOnlineUsers) (*status.Vector_Long, error) {
	// TODO: not impl
	logx.WithContext(ctx).Errorf("status.getChannelOnlineUsers blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}

// StatusSetUserChannelsOnline
// status.setUserChannelsOnline user_id:long channels:Vector<long> = Bool;
func (s *Service) StatusSetUserChannelsOnline(ctx context.Context, request *status.TLStatusSetUserChannelsOnline) (*mtproto.Bool, error) {
	// TODO: not impl
	logx.WithContext(ctx).Errorf("status.setUserChannelsOnline blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}

// StatusSetUserChannelsOffline
// status.setUserChannelsOffline user_id:long channels:Vector<long> = Bool;
func (s *Service) StatusSetUserChannelsOffline(ctx context.Context, request *status.TLStatusSetUserChannelsOffline) (*mtproto.Bool, error) {
	// TODO: not impl
	logx.WithContext(ctx).Errorf("status.setUserChannelsOffline blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")

	return nil, mtproto.ErrEnterpriseIsBlocked
}

// StatusSetChannelUserOffline
// status.setChannelUserOffline channel_id:long user_id:long = Bool;
func (s *Service) StatusSetChannelUserOffline(ctx context.Context, request *status.TLStatusSetChannelUserOffline) (*mtproto.Bool, error) {
	// TODO: not impl
	logx.WithContext(ctx).Errorf("status.setChannelUserOffline blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")
	return nil, mtproto.ErrEnterpriseIsBlocked
}

// StatusSetChannelUsersOnline
// status.setChannelUsersOnline channel_id:long user_id:long = Bool;
func (s *Service) StatusSetChannelUsersOnline(ctx context.Context, request *status.TLStatusSetChannelUsersOnline) (*mtproto.Bool, error) {
	// TODO: not impl
	logx.WithContext(ctx).Errorf("status.setChannelUsersOnline blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")
	return nil, mtproto.ErrEnterpriseIsBlocked
}

// StatusSetChannelOffline
// status.setChannelOffline channel_id:long = Bool;
func (s *Service) StatusSetChannelOffline(ctx context.Context, request *status.TLStatusSetChannelOffline) (*mtproto.Bool, error) {
	// TODO: not impl
	logx.WithContext(ctx).Errorf("status.setChannelOffline blocked, License key from https://wb.playwith-me.com required to unlock enterprise features.")
	return nil, mtproto.ErrEnterpriseIsBlocked
}
