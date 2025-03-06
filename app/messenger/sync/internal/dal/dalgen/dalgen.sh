#!/bin/bash

dalgen3 --xml=$1 --db=teamgram --go2=pwm-server/app/messenger/sync/internal/dal/dataobject

gofmt -w ../dao/mysql_dao/*.go
gofmt -w ../dataobject/*.go
