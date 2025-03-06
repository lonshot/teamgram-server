#!/usr/bin/env bash

PWD=`pwd`
PWM_APP=${PWD}"/app"
echo ${PWD}

cd ${PWM_APP}/messenger/msg/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/messenger/sync/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/bff/authorization/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/service/biz/chat/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/service/biz/message/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/service/biz/user/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/service/biz/updates/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/service/biz/dialog/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/service/biz/username/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/service/authsession/internal/dal/dalgen
./dalgen_all.sh

cd ${PWM_APP}/service/media/internal/dal/dalgen
./dalgen_all.sh

