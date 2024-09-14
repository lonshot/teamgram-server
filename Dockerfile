# First stage: Build Delve using Golang Alpine
FROM golang:1.14.3-alpine3.11 AS build-env

ENV CGO_ENABLED 0

# Allow Go to retrieve the dependencies for the build step
RUN apk add --no-cache git

# Set the working directory
WORKDIR /go/src/

# Get Delve debugger from GOPATH (not from Go Modules)
RUN go get github.com/go-delve/delve/cmd/dlv

# Second stage: Final container using Ubuntu
FROM ubuntu:22.04

# Set the working directory
WORKDIR /app

# Install FFmpeg, curl, and other dependencies
RUN apt update -y && \
    apt install -y ffmpeg curl git

# Copy the Delve binary from the build stage
COPY --from=build-env /go/bin/dlv /usr/local/bin/dlv

# Expose the Delve debugging port
EXPOSE 40000
