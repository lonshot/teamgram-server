#!/bin/bash

# Redis Admin Proxy Management Script

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
COMPOSE_FILE="$PROJECT_ROOT/docker-compose-env.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    echo "Redis Admin Proxy Management Script"
    echo ""
    echo "Usage: $0 {start|stop|restart|status|logs|build|help}"
    echo ""
    echo "Commands:"
    echo "  start     Start the Redis admin proxy service"
    echo "  stop      Stop the Redis admin proxy service"
    echo "  restart   Restart the Redis admin proxy service"
    echo "  status    Show service status"
    echo "  logs      Show service logs"
    echo "  build     Build the Docker image"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start                    # Start the service"
    echo "  $0 logs -f                  # Follow logs"
    echo "  $0 status                   # Check if running"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Error: Docker is not installed${NC}"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}Error: Docker Compose is not installed${NC}"
        exit 1
    fi
}

start_service() {
    echo -e "${BLUE}Starting Redis Admin Proxy...${NC}"
    
    # Check if Redis is running first
    if ! docker-compose -f "$COMPOSE_FILE" ps redis | grep -q "Up"; then
        echo -e "${YELLOW}Redis service is not running. Starting Redis first...${NC}"
        docker-compose -f "$COMPOSE_FILE" up -d redis
        echo -e "${GREEN}Waiting for Redis to be ready...${NC}"
        sleep 5
    fi
    
    # Start the proxy
    docker-compose -f "$COMPOSE_FILE" up -d redis-admin-proxy
    
    echo -e "${GREEN}Redis Admin Proxy started successfully!${NC}"
    echo -e "${BLUE}Service available on port 6380${NC}"
    echo -e "${BLUE}Admin password: admin_redis_2025!${NC}"
    echo ""
    echo "Test connection:"
    echo "  redis-cli -h localhost -p 6380"
    echo "  > AUTH admin_redis_2025!"
    echo "  > PING"
}

stop_service() {
    echo -e "${BLUE}Stopping Redis Admin Proxy...${NC}"
    docker-compose -f "$COMPOSE_FILE" stop redis-admin-proxy
    echo -e "${GREEN}Redis Admin Proxy stopped${NC}"
}

restart_service() {
    echo -e "${BLUE}Restarting Redis Admin Proxy...${NC}"
    docker-compose -f "$COMPOSE_FILE" restart redis-admin-proxy
    echo -e "${GREEN}Redis Admin Proxy restarted${NC}"
}

show_status() {
    echo -e "${BLUE}Redis Admin Proxy Status:${NC}"
    echo ""
    
    # Check if container exists and its status
    if docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep redis-admin-proxy; then
        echo ""
        echo -e "${BLUE}Container Details:${NC}"
        docker-compose -f "$COMPOSE_FILE" ps redis-admin-proxy
    else
        echo -e "${YELLOW}Redis Admin Proxy container not found${NC}"
        echo "Run '$0 start' to start the service"
    fi
    
    # Check if port is accessible
    echo ""
    echo -e "${BLUE}Port Check:${NC}"
    if nc -z localhost 6380 2>/dev/null; then
        echo -e "${GREEN}✓ Port 6380 is accessible${NC}"
    else
        echo -e "${RED}✗ Port 6380 is not accessible${NC}"
    fi
}

show_logs() {
    echo -e "${BLUE}Redis Admin Proxy Logs:${NC}"
    docker-compose -f "$COMPOSE_FILE" logs "${@:1}" redis-admin-proxy
}

build_image() {
    echo -e "${BLUE}Building Redis Admin Proxy Docker image...${NC}"
    docker-compose -f "$COMPOSE_FILE" build redis-admin-proxy
    echo -e "${GREEN}Build completed successfully!${NC}"
}

# Main script logic
case "${1:-}" in
    start)
        check_docker
        start_service
        ;;
    stop)
        check_docker
        stop_service
        ;;
    restart)
        check_docker
        restart_service
        ;;
    status)
        check_docker
        show_status
        ;;
    logs)
        check_docker
        shift
        show_logs "$@"
        ;;
    build)
        check_docker
        build_image
        ;;
    help|--help|-h)
        usage
        ;;
    "")
        usage
        exit 1
        ;;
    *)
        echo -e "${RED}Error: Unknown command '$1'${NC}"
        echo ""
        usage
        exit 1
        ;;
esac