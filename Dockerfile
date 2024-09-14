FROM ubuntu:22.04

# Set the working directory
WORKDIR /app

# Install FFmpeg, curl, and other dependencies
RUN apt update -y && \
    apt install -y ffmpeg curl git

# Check if Go tarball exists in the mounted directory, otherwise download it
RUN if [ ! -f /mnt/go1.21.13.linux-amd64.tar.gz ]; then \
        curl -OL https://go.dev/dl/go1.21.13.linux-amd64.tar.gz && \
        tar -C /usr/local -xzf go1.21.13.linux-amd64.tar.gz; \
    else \
        tar -C /usr/local -xzf /mnt/go1.21.13.linux-amd64.tar.gz; \
    fi

# Set the Go binary in the PATH
ENV PATH=$PATH:/usr/local/go/bin

# Install Delve debugger for Go
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Expose port 40000 for Delve debugger
EXPOSE 40000

# Set permissions for entrypoint script and make it executable
RUN chmod +x /app/docker/entrypoint.sh

# Entry point to run Delve for debugging
ENTRYPOINT [ "dlv", "debug", "--headless", "--listen=:40000", "--api-version=2", "--log", "--accept-multiclient", "--", "/app/docker/entrypoint.sh" ]
