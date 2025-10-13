# Redis Admin Proxy

A secure proxy service that provides authenticated access to Redis for administrative purposes only. This service acts as a gateway between external admin tools and the internal Redis instance.

## Features

- **Password Authentication**: Requires admin password before allowing any Redis operations
- **Connection Limiting**: Configurable maximum concurrent connections
- **Protocol Compatibility**: Full Redis protocol support via transparent proxying
- **Logging**: Detailed connection and operation logging
- **Graceful Shutdown**: Proper connection handling during service restart
- **Docker Ready**: Includes Dockerfile and Docker Compose integration

## Architecture

```
[Admin Tools] → [Redis Admin Proxy:6380] → [Internal Redis:6379]
                      ↑
              Password Protected
```

## Quick Start

### Using Docker Compose

1. Start the services:
   ```bash
   docker-compose -f docker-compose-env.yaml up redis-admin-proxy
   ```

2. Connect using redis-cli:
   ```bash
   redis-cli -h localhost -p 6380
   127.0.0.1:6380> AUTH admin_redis_2025!
   OK
   127.0.0.1:6380> PING
   PONG
   ```

### Building and Running Locally

1. Build the proxy:
   ```bash
   ./scripts/build-redis-proxy.sh
   ```

2. Run the proxy:
   ```bash
   ./bin/redis-admin-proxy
   ```

3. Or with custom settings:
   ```bash
   REDIS_ADMIN_PASSWORD=mypassword REDIS_PROXY_PORT=6381 ./bin/redis-admin-proxy
   ```

## Configuration

The service is configured via environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `REDIS_PROXY_HOST` | `0.0.0.0` | Proxy server bind address |
| `REDIS_PROXY_PORT` | `6380` | Proxy server port |
| `REDIS_ADMIN_PASSWORD` | `admin_redis_2025!` | Admin password for proxy access |
| `REDIS_HOST` | `redis` | Backend Redis host |
| `REDIS_PORT` | `6379` | Backend Redis port |
| `REDIS_PASSWORD` | `A65D0770B69940FEA084C9C8028908F7` | Backend Redis password |
| `REDIS_MAX_CONNECTIONS` | `100` | Maximum concurrent connections |
| `REDIS_ENABLE_LOGGING` | `true` | Enable detailed logging |

## Security Features

### Authentication Required
Every client must authenticate with the admin password before accessing Redis:
```bash
redis-cli -h proxy-host -p 6380
> AUTH admin_redis_2025!
OK
```

### Connection Limiting
The proxy limits concurrent connections to prevent resource exhaustion:
- Default limit: 100 connections
- Configurable via `REDIS_MAX_CONNECTIONS`
- Rejects new connections when limit is reached

### Internal Network Only
The proxy is designed to run on internal networks only. For external access:
1. Use VPN or secure tunnels
2. Configure firewall rules appropriately
3. Consider additional authentication layers

## Usage Examples

### Basic Operations
```bash
# Connect and authenticate
redis-cli -h localhost -p 6380
> AUTH admin_redis_2025!
OK

# Basic Redis operations
> PING
PONG
> SET test_key "test_value"
OK
> GET test_key
"test_value"
```

### Administrative Commands
```bash
# View Redis info
> INFO
# Redis server information...

# Monitor connections
> CLIENT LIST
# Active client connections...

# Database operations
> FLUSHDB
OK
```

### Using with Redis Desktop Manager
1. Create new connection
2. Host: `your-server-ip`
3. Port: `6380`
4. Auth: `admin_redis_2025!`

### Using with RedisInsight
1. Add database
2. Connection Type: Standalone
3. Host: `your-server-ip`
4. Port: `6380` 
5. Password: `admin_redis_2025!`

## Docker Configuration

### Environment Variables in Docker Compose
```yaml
redis-admin-proxy:
  environment:
    REDIS_ADMIN_PASSWORD: "your_secure_password_here"
    REDIS_PROXY_PORT: 6380
    REDIS_MAX_CONNECTIONS: 50
```

### Port Mapping
```yaml
ports:
  - "6380:6380"  # External:Internal
```

## Troubleshooting

### Common Issues

1. **Connection Refused**
   - Check if proxy service is running
   - Verify port is not blocked by firewall
   - Ensure Docker containers are on same network

2. **Authentication Failed**
   - Verify `REDIS_ADMIN_PASSWORD` is correct
   - Check for typos in password
   - Ensure AUTH command is first command sent

3. **Backend Connection Failed**
   - Verify Redis service is running
   - Check `REDIS_HOST` and `REDIS_PORT` settings
   - Validate `REDIS_PASSWORD` for backend

4. **Max Connections Exceeded**
   - Increase `REDIS_MAX_CONNECTIONS`
   - Check for connection leaks in client applications
   - Monitor connection usage patterns

### Logging

Enable detailed logging for debugging:
```bash
REDIS_ENABLE_LOGGING=true ./bin/redis-admin-proxy
```

Logs include:
- Connection establishment/termination
- Authentication attempts
- Backend connection status
- Error conditions

### Health Checks

Test proxy health:
```bash
# Test connectivity
redis-cli -h localhost -p 6380 ping

# Test authentication
redis-cli -h localhost -p 6380 -a admin_redis_2025! ping
```

## Production Deployment

### Recommended Settings
```yaml
environment:
  REDIS_ADMIN_PASSWORD: "use-strong-random-password-here"
  REDIS_MAX_CONNECTIONS: 20
  REDIS_ENABLE_LOGGING: "true"
```

### Security Checklist
- [ ] Use strong, unique admin password
- [ ] Limit connections based on expected usage
- [ ] Monitor logs for unauthorized access attempts
- [ ] Run on internal network only
- [ ] Use firewall rules to restrict access
- [ ] Regularly rotate admin password
- [ ] Monitor connection patterns

### Monitoring
- Track connection count trends
- Monitor authentication failure rates
- Alert on service availability
- Log analysis for access patterns

## Development

### Building from Source
```bash
# Install dependencies
go mod tidy

# Run tests (if any)
go test ./pkg/redis-proxy/...

# Build
go build -o redis-admin-proxy ./cmd/redis-admin-proxy
```

### Project Structure
```
pkg/redis-proxy/
├── config.go      # Configuration management
└── proxy.go       # Core proxy implementation

cmd/redis-admin-proxy/
└── main.go        # Application entry point

docker/
└── redis-proxy.Dockerfile  # Container build

scripts/
└── build-redis-proxy.sh     # Build automation
```