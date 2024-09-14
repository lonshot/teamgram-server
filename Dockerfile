FROM ubuntu:22.04

# Set the working directory
WORKDIR /app

# Use the Go binary from the host (we'll mount it in the docker-compose.yml)
ENV PATH=$PATH:/usr/local/go/bin

# Install Delve debugger for Go (this will use the Go installation from the mounted volume)
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Install FFmpeg, curl, and other dependencies
RUN apt update -y && \
    apt install -y ffmpeg curl git

# Expose port 40000 for Delve debugger
EXPOSE 40000

# Set permissions for entrypoint script and make it executable
RUN chmod +x /app/docker/entrypoint.sh

# Entry point to run Delve for debugging
ENTRYPOINT [ "dlv", "debug", "--headless", "--listen=:40000", "--api-version=2", "--log", "--accept-multiclient", "--", "/app/docker/entrypoint.sh" ]
