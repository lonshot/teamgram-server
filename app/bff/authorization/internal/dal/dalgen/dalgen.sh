#!/bin/bash

dalgen3 --xml=$1 --db=teamgram --go2=pwm-server/app/bff/authorization/internal/dal/dataobject

gofmt -w ../dao/mysql_dao/*.go
gofmt -w ../dataobject/*.go
