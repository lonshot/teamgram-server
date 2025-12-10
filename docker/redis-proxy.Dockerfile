# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY pkg/redis-proxy ./pkg/redis-proxy
COPY cmd/redis-admin-proxy ./cmd/redis-admin-proxy

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o redis-admin-proxy ./cmd/redis-admin-proxy

# Final stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata
WORKDIR /root/

# Copy the binary from builder stage
COPY --from=builder /app/redis-admin-proxy .

# Create non-root user
RUN adduser -D -s /bin/sh proxyuser
USER proxyuser

EXPOSE 6380

CMD ["./redis-admin-proxy"]