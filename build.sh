#!/usr/bin/env bash

PWD=`pwd`
PWM_APP=${PWD}"/app"
INSTALL=${PWD}"/pwm"

echo "build idgen ..."
cd ${PWM_APP}/service/idgen/cmd/idgen
go build -o ${INSTALL}/bin/idgen

echo "build status ..."
cd ${PWM_APP}/service/status/cmd/status
go build -o ${INSTALL}/bin/status

echo "build dfs ..."
cd ${PWM_APP}/service/dfs/cmd/dfs
go build -o ${INSTALL}/bin/dfs

echo "build media ..."
cd ${PWM_APP}/service/media/cmd/media
go build -o ${INSTALL}/bin/media

echo "build authsession ..."
cd ${PWM_APP}/service/authsession/cmd/authsession
go build -o ${INSTALL}/bin/authsession

echo "build biz ..."
cd ${PWM_APP}/service/biz/biz/cmd/biz
go build -o ${INSTALL}/bin/biz

echo "build msg ..."
cd ${PWM_APP}/messenger/msg/cmd/msg
go build -o ${INSTALL}/bin/msg

echo "build sync ..."
cd ${PWM_APP}/messenger/sync/cmd/sync
go build -o ${INSTALL}/bin/sync

echo "build bff ..."
cd ${PWM_APP}/bff/bff/cmd/bff
go build -o ${INSTALL}/bin/bff

echo "build session ..."
cd ${PWM_APP}/interface/session/cmd/session
go build -o ${INSTALL}/bin/session

echo "build gateway ..."
cd ${PWM_APP}/interface/gateway/cmd/gateway
go build -o ${INSTALL}/bin/gateway

echo "build gnetway ..."
cd ${PWM_APP}/interface/gnetway/cmd/gnetway
go build -o ${INSTALL}/bin/gnetway

#echo "build httpserver ..."
#cd ${PWM_APP}/interface/httpserver/cmd/httpserver
#go build -o ${INSTALL}/bin/httpserver
