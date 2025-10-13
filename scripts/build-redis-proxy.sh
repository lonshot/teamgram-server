#!/bin/bash

# Redis Admin Proxy Build Script

set -e

echo "Building Redis Admin Proxy..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Go is not installed. Please install Go 1.21 or later."
    exit 1
fi

# Get the current directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$SCRIPT_DIR"

# Build the proxy
echo "Building redis-admin-proxy binary..."
cd "$PROJECT_ROOT"

# Create bin directory if it doesn't exist
mkdir -p bin

# Build for the current platform
CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags '-w -s' -o bin/redis-admin-proxy ./cmd/redis-admin-proxy

# Build for Linux (for Docker)
echo "Building linux binary for Docker..."
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags '-w -s' -o bin/redis-admin-proxy-linux ./cmd/redis-admin-proxy

echo "Build completed successfully!"
echo "Binaries available in: $PROJECT_ROOT/bin/"
echo ""
echo "To run locally:"
echo "  ./bin/redis-admin-proxy --help"
echo ""
echo "To build Docker image:"
echo "  docker build -f docker/redis-proxy.Dockerfile -t redis-admin-proxy ."
echo ""
echo "To run with Docker Compose:"
echo "  docker-compose -f docker-compose-env.yaml up redis-admin-proxy"