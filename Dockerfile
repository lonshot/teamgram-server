# Base image: Ubuntu 22.04
FROM ubuntu:22.04

# Install necessary packages including curl, git, and dependencies for Go
RUN apt update -y && \
    apt install -y ffmpeg curl git tar

# Remove any existing Go installation and download/install Go
RUN echo "Downloading Go" && \
    curl -o /tmp/go1.21.13.linux-amd64.tar.gz https://dl.google.com/go/go1.21.13.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go1.21.13.linux-amd64.tar.gz && \
    rm /tmp/go1.21.13.linux-amd64.tar.gz

# Set up Go environment
ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=0

# Install Delve using 'go install' and copy the binary to /usr/local/bin
RUN /usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest && \
    cp /root/go/bin/dlv /usr/local/bin/dlv

# Expose the Delve debugging port
EXPOSE 40000
