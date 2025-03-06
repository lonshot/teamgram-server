VERSION=v0.0.1-pwm-server
BUILD=`date +%F`
SHELL := /bin/bash
BASEDIR = $(shell pwd)

# Get version info from Git
versionDir="github.com/teamgram/marmota/pkg/version"
gitTag=$(shell if [ "`git describe --tags --abbrev=0 2>/dev/null`" != "" ];then git describe --tags --abbrev=0; else git log --pretty=format:'%h' -n 1; fi)
gitBranch=$(shell git rev-parse --abbrev-ref HEAD)
buildDate=$(shell TZ=Asia/Ho_Chi_Minh date +%FT%T%z)
gitCommit=$(shell git rev-parse --short HEAD)
gitTreeState=$(shell if git status|grep -q 'clean';then echo clean; else echo dirty; fi)

ldflags="-s -w -X ${versionDir}.gitTag=${gitTag} -X ${versionDir}.buildDate=${buildDate} -X ${versionDir}.gitCommit=${gitCommit} -X ${versionDir}.gitTreeState=${gitTreeState} -X ${versionDir}.version=${VERSION} -X ${versionDir}.gitBranch=${gitBranch}"

# Main entry point for building services
all: idgen status dfs media authsession biz msg sync bff session gateway gnetway httpserver

idgen:
	@echo "Building idgen..."
	@go build -ldflags ${ldflags} -o pwm/bin/idgen -tags=jsoniter app/service/idgen/cmd/idgen/*.go

status:
	@echo "Building status..."
	@go build -ldflags ${ldflags} -o pwm/bin/status -tags=jsoniter app/service/status/cmd/status/*.go

dfs:
	@echo "Building dfs..."
	@go build -ldflags ${ldflags} -o pwm/bin/dfs -tags=jsoniter app/service/dfs/cmd/dfs/*.go

media:
	@echo "Building media..."
	@go build -ldflags ${ldflags} -o pwm/bin/media -tags=jsoniter app/service/media/cmd/media/*.go

authsession:
	@echo "Building authsession..."
	@go build -ldflags ${ldflags} -o pwm/bin/authsession -tags=jsoniter app/service/authsession/cmd/authsession/*.go

biz:
	@echo "Building biz..."
	@go build -ldflags ${ldflags} -o pwm/bin/biz -tags=jsoniter app/service/biz/biz/cmd/biz/*.go

msg:
	@echo "Building msg..."
	@go build -ldflags ${ldflags} -o pwm/bin/msg -tags=jsoniter app/messenger/msg/cmd/msg/*.go

sync:
	@echo "Building sync..."
	@go build -ldflags ${ldflags} -o pwm/bin/sync -tags=jsoniter app/messenger/sync/cmd/sync/*.go

bff:
	@echo "Building bff..."
	@go build -ldflags ${ldflags} -o pwm/bin/bff -tags=jsoniter app/bff/bff/cmd/bff/*.go

session:
	@echo "Building session..."
	@go build -ldflags ${ldflags} -o pwm/bin/session -tags=jsoniter app/interface/session/cmd/session/*.go

gateway:
	@echo "Building gateway..."
	@go build -ldflags ${ldflags} -o pwm/bin/gateway -tags=jsoniter app/interface/gateway/cmd/gateway/*.go

gnetway:
	@echo "Building gnetway..."
	@go build -ldflags ${ldflags} -o pwm/bin/gnetway -tags=jsoniter app/interface/gnetway/cmd/gnetway/*.go

httpserver:
	@echo "Building httpserver..."
	@go build -ldflags ${ldflags} -o pwm/bin/httpserver -tags=jsoniter app/interface/httpserver/cmd/httpserver/*.go

# Clean binary files
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

# Clean logs directory
clean-logs:
	@echo "Cleaning logs..."
	rm -rf pwm/logs/*

# Stop the main service containers
stop-main:
	@echo "Stopping main service..."
	docker compose down

# Stop all containers (dependencies + main service)
stop-all:
	@echo "Stopping all containers..."
	docker compose down
	docker compose -f ./docker-compose-env.yaml down

# Reset data and stop all containers
reset:
	@echo "Resetting data..."
	docker compose down
	docker compose -f ./docker-compose-env.yaml down
	rm -rf data
	mkdir data

# Start shared network
start-network:
	@echo "Checking if the shared network 'pwm_shared_network' exists..."
	@if ! docker network ls --format '{{.Name}}' | grep -q '^pwm_shared_network$$'; then \
		echo "Shared network 'pwm_shared_network' does not exist. Creating..."; \
		docker network create --driver bridge --subnet=172.20.0.0/16 pwm_shared_network; \
	else \
		echo "Shared network 'pwm_shared_network' already exists."; \
	fi

# Start dependencies (e.g., MySQL, MinIO)
start-deps: start-network
	@echo "Starting dependencies..."
	docker compose -f ./docker-compose-env.yaml up -d

# Stop dependencies containers
stop-deps:
	@echo "Stopping dependencies..."
	docker compose -f ./docker-compose-env.yaml down

# Force rebuild and start main service
force-rebuild:
	@echo "Rebuilding and starting main service..."
	docker compose up --build -d
	docker compose logs --tail 100 -f

# Start main service and tail logs
start-main:
	@echo "Starting main service..."
	docker compose down
	docker compose up -d 
	docker compose logs --tail 100 -f

# Clean up unused docker resources
prune:
	docker system prune -a

check:
	sudo lsof -i:$(port)

listen:
	sudo lsof -i -P -n | grep LISTEN

# Pull latest updates from git
pull:
	git reset --hard
	git pull

# Restart services after pulling updates
restart: stop-main pull start-main

# Show logs for all services
log-deps:
	@echo "Showing logs for all services..."
	docker compose -f ./docker-compose-env.yaml logs --tail 100 -f

log-main:
	@echo "Showing logs for main..."
	docker compose logs --tail 100 -f

# Additional target to tail docker logs in a different format
docker-logs:
	docker compose logs -f --tail=200
