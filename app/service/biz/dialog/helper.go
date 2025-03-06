/*
 * WARNING! All changes made in this file will be lost!
 * Created from 'scheme.tl' by 'mtprotoc'
 *
 * Copyright (c) 2021-present,  Teamgram Studio (https://teamgram.io).
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

package dialog_helper

import (
	"pwm-server/app/service/biz/dialog/internal/config"
	"pwm-server/app/service/biz/dialog/internal/dal/dao/mysql_dao"
	"pwm-server/app/service/biz/dialog/internal/dal/dataobject"
	"pwm-server/app/service/biz/dialog/internal/server/grpc/service"
	"pwm-server/app/service/biz/dialog/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}

type (
	DialogsDAO      = mysql_dao.DialogsDAO
	DialogsDO       = dataobject.DialogsDO
	SavedDialogsDAO = mysql_dao.SavedDialogsDAO
	SavedDialogsDO  = dataobject.SavedDialogsDO
)

var (
	NewDialogsDAO      = mysql_dao.NewDialogsDAO
	NewSavedDialogsDAO = mysql_dao.NewSavedDialogsDAO
)
