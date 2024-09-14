FROM golang:1.14.3-alpine3.11 AS build-env

ENV CGO_ENABLED 0

# Allow Go to retreive the dependencies for the build step
RUN apk add --no-cache git

# Get Delve from a GOPATH not from a Go Modules project
WORKDIR /go/src/
RUN go get github.com/go-delve/delve/cmd/dlv

FROM ubuntu:22.04
# Set the working directory
WORKDIR /app

# Install FFmpeg, curl, and other dependencies
RUN apt update -y && \
    apt install -y ffmpeg curl git \

COPY --from=build-env /go/bin/dlv /app

# Expose ports for the application and Delve debugger
EXPOSE 40000
