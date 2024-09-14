# Base image: Ubuntu 22.04
FROM ubuntu:22.04

# Set the working directory
WORKDIR /app

# Install necessary packages including curl, git, and dependencies for Go
RUN apt update -y && \
    apt install -y ffmpeg curl git tar

# Mount the host's home directory to /mnt inside the container
# You will need to set this up when running the container using -v ~/:/mnt
# The next step will check for the Go tarball in /mnt (host home directory)

# Check if go1.21.13.linux-amd64.tar.gz exists in /mnt (mounted from host home)
# Check if go1.21.13.linux-amd64.tar.gz exists in /mnt (mounted from host home) and install Go
RUN rm -rf /usr/local/go && \
    if [ -f /mnt/go1.21.13.linux-amd64.tar.gz ]; then \
        echo "Using existing Go archive from /mnt" && \
        tar -C /usr/local -xzf /mnt/go1.21.13.linux-amd64.tar.gz; \
    else \
        echo "Downloading Go" && \
        curl -o /tmp/go1.21.13.linux-amd64.tar.gz https://go.dev/dl/go1.21.13.linux-amd64.tar.gz && \
        tar -C /usr/local -xzf /tmp/go1.21.13.linux-amd64.tar.gz && \
        rm /tmp/go1.21.13.linux-amd64.tar.gz; \
    fi

# Set up Go environment
ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=0

# Install Delve using 'go install'
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Expose the Delve debugging port
EXPOSE 40000
