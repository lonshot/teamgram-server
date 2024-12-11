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
	rm -rf pwm/bin/*

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

# Start dependencies (e.g., MySQL, MinIO)
start-deps:
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

# Pull latest updates from git
pull:
	git reset --hard
	git pull

# Restart services after pulling updates
restart: stop-main pull start-main

# Show logs for all services
logs-all:
	@echo "Showing logs for all services..."
	docker compose logs --tail 100 -f

# Show logs for a specific service (use: make logs-service service=<service-name>)
logs-service:
	@echo "Showing logs for $(service)..."
	docker compose logs --tail 100 -f $(service)

# Additional target to tail docker logs in a different format
docker-logs:
	docker compose logs -f --tail=200
