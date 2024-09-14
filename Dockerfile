# First stage: Build Delve using Golang Alpine 1.21
FROM golang:1.21-alpine AS build-env

ENV CGO_ENABLED 0

# Install git for Go dependencies
RUN apk add --no-cache git

# Set the working directory
WORKDIR /go/src/

# Install Delve using 'go install' (the preferred method in Go 1.16+)
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Second stage: Final container using Ubuntu 22.04
FROM ubuntu:22.04

# Set the working directory
WORKDIR /app

# Copy the Delve binary from the build stage
COPY --from=build-env /go/bin/dlv /app/dlv

# Install FFmpeg, curl, and other dependencies
RUN apt update -y && \
    apt install -y ffmpeg curl git

# Expose the Delve debugging port
EXPOSE 40000
