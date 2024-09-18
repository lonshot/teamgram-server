VERSION=v0.0.1-pwm-server
BUILD=`date +%F`
SHELL := /bin/bash
BASEDIR = $(shell pwd)

# build with verison infos
versionDir="github.com/teamgram/marmota/pkg/version"
gitTag=$(shell if [ "`git describe --tags --abbrev=0 2>/dev/null`" != "" ];then git describe --tags --abbrev=0; else git log --pretty=format:'%h' -n 1; fi)
gitBranch=$(shell git rev-parse --abbrev-ref HEAD)
buildDate=$(shell TZ=Asia/Ho_Chi_Minh date +%FT%T%z)
gitCommit=$(shell git rev-parse --short HEAD)
gitTreeState=$(shell if git status|grep -q 'clean';then echo clean; else echo dirty; fi)

ldflags="-s -w -X ${versionDir}.gitTag=${gitTag} -X ${versionDir}.buildDate=${buildDate} -X ${versionDir}.gitCommit=${gitCommit} -X ${versionDir}.gitTreeState=${gitTreeState} -X ${versionDir}.version=${VERSION} -X ${versionDir}.gitBranch=${gitBranch}"

all: idgen status dfs media authsession biz msg sync bff session gateway gnetway

idgen:
	@echo "build idgen..."
	@go build -ldflags ${ldflags} -o pwm/bin/idgen -tags=jsoniter app/service/idgen/cmd/idgen/*.go

status:
	@echo "build status..."
	@go build -ldflags ${ldflags} -o pwm/bin/status -tags=jsoniter app/service/status/cmd/status/*.go

dfs:
	@echo "build dfs..."
	@go build -ldflags ${ldflags} -o pwm/bin/dfs -tags=jsoniter app/service/dfs/cmd/dfs/*.go

media:
	@echo "build media..."
	@go build -ldflags ${ldflags} -o pwm/bin/media -tags=jsoniter app/service/media/cmd/media/*.go

authsession:
	@echo "build authsession..."
	@go build -ldflags ${ldflags} -o pwm/bin/authsession -tags=jsoniter app/service/authsession/cmd/authsession/*.go

biz:
	@echo "build biz..."
	@go build -ldflags ${ldflags} -o pwm/bin/biz -tags=jsoniter app/service/biz/biz/cmd/biz/*.go

msg:
	@echo "build msg..."
	@go build -ldflags ${ldflags} -o pwm/bin/msg -tags=jsoniter app/messenger/msg/cmd/msg/*.go

sync:
	@echo "build sync..."
	@go build -ldflags ${ldflags} -o pwm/bin/sync -tags=jsoniter app/messenger/sync/cmd/sync/*.go

bff:
	@echo "build bff..."
	@go build -ldflags ${ldflags} -o pwm/bin/bff -tags=jsoniter app/bff/bff/cmd/bff/*.go

session:
	@echo "build session..."
	@go build -ldflags ${ldflags} -o pwm/bin/session -tags=jsoniter app/interface/session/cmd/session/*.go

gateway:
	@echo "build gateway..."
	@go build -ldflags ${ldflags} -o pwm/bin/gateway -tags=jsoniter app/interface/gateway/cmd/gateway/*.go

gnetway:
	@echo "build gnetway..."
	@go build -ldflags ${ldflags} -o pwm/bin/gnetway -tags=jsoniter app/interface/gnetway/cmd/gnetway/*.go

httpserver:
	@echo "build httpserver..."
	@go build -ldflags ${ldflags} -o pwm/bin/httpserver -tags=jsoniter app/interface/httpserver/cmd/httpserver/*.go

clean:
	rm -rf pwm/bin/idgen
	rm -rf pwm/bin/status
	rm -rf pwm/bin/dfs
	rm -rf pwm/bin/media
	rm -rf pwm/bin/authsession
	rm -rf pwm/bin/biz
	rm -rf pwm/bin/msg
	rm -rf pwm/bin/sync
	rm -rf pwm/bin/bff
	rm -rf pwm/bin/session
	rm -rf pwm/bin/gateway
	rm -rf pwm/bin/gnetway
	rm -rf pwm/bin/httpserver

clean-logs:
	@echo "Cleaning logs..."
	rm -rf pwm/logs/* 

stop:
	@echo "Stopping main docker..."
	docker compose down

stopa:
	@echo "Stopping all dockers..."
	docker compose down
	docker compose -f ./docker-compose-env.yaml down

reset:
	@echo "Resetting all data..."
	docker compose down
	docker compose -f ./docker-compose-env.yaml down
	rm -rf data
	mkdir data

deps:
	docker compose -f ./docker-compose-env.yaml up -d

deps-stop:
	docker compose -f ./docker-compose-env.yaml down

run-force:
	docker compose up --build -d
	docker compose logs --tail 100 -f

prune:
	docker system prune -a

run:
	docker compose up -d 
	docker compose logs --tail 100 -f

pull:
	git reset --hard
	git pull

restart: stop pull run