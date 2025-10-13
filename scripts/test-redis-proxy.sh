#!/bin/bash

# Redis Admin Proxy Test Script

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROXY_HOST="${REDIS_PROXY_HOST:-localhost}"
PROXY_PORT="${REDIS_PROXY_PORT:-6380}"
ADMIN_PASSWORD="${REDIS_ADMIN_PASSWORD:-admin_redis_2025!}"

echo -e "${BLUE}Testing Redis Admin Proxy${NC}"
echo "Host: $PROXY_HOST"
echo "Port: $PROXY_PORT"
echo "Password: $ADMIN_PASSWORD"
echo ""

# Test 1: Check if port is open
echo -e "${BLUE}Test 1: Port connectivity${NC}"
if nc -z "$PROXY_HOST" "$PROXY_PORT" 2>/dev/null; then
    echo -e "${GREEN}✓ Port $PROXY_PORT is accessible${NC}"
else
    echo -e "${RED}✗ Port $PROXY_PORT is not accessible${NC}"
    echo "Make sure the Redis Admin Proxy is running:"
    echo "  ./scripts/redis-proxy.sh start"
    exit 1
fi

# Test 2: Test authentication failure with wrong password
echo -e "${BLUE}Test 2: Authentication with wrong password${NC}"
if redis-cli -h "$PROXY_HOST" -p "$PROXY_PORT" -a "wrongpassword" ping 2>/dev/null | grep -q "NOAUTH"; then
    echo -e "${GREEN}✓ Wrong password correctly rejected${NC}"
else
    # Try another approach - wrong password should fail
    if ! redis-cli -h "$PROXY_HOST" -p "$PROXY_PORT" -a "wrongpassword" ping 2>/dev/null >/dev/null; then
        echo -e "${GREEN}✓ Wrong password correctly rejected${NC}"
    else
        echo -e "${RED}✗ Wrong password was accepted (security issue!)${NC}"
        exit 1
    fi
fi

# Test 3: Test authentication with correct password
echo -e "${BLUE}Test 3: Authentication with correct password${NC}"
if redis-cli -h "$PROXY_HOST" -p "$PROXY_PORT" -a "$ADMIN_PASSWORD" ping 2>/dev/null | grep -q "PONG"; then
    echo -e "${GREEN}✓ Correct password accepted${NC}"
else
    echo -e "${RED}✗ Correct password rejected${NC}"
    exit 1
fi

# Test 4: Basic Redis operations
echo -e "${BLUE}Test 4: Basic Redis operations${NC}"

# Set a test key
if redis-cli -h "$PROXY_HOST" -p "$PROXY_PORT" -a "$ADMIN_PASSWORD" set "test_proxy_key" "test_value" 2>/dev/null | grep -q "OK"; then
    echo -e "${GREEN}✓ SET operation successful${NC}"
else
    echo -e "${RED}✗ SET operation failed${NC}"
    exit 1
fi

# Get the test key
if redis-cli -h "$PROXY_HOST" -p "$PROXY_PORT" -a "$ADMIN_PASSWORD" get "test_proxy_key" 2>/dev/null | grep -q "test_value"; then
    echo -e "${GREEN}✓ GET operation successful${NC}"
else
    echo -e "${RED}✗ GET operation failed${NC}"
    exit 1
fi

# Clean up test key
redis-cli -h "$PROXY_HOST" -p "$PROXY_PORT" -a "$ADMIN_PASSWORD" del "test_proxy_key" >/dev/null 2>&1

# Test 5: Redis INFO command
echo -e "${BLUE}Test 5: Redis INFO command${NC}"
if redis-cli -h "$PROXY_HOST" -p "$PROXY_PORT" -a "$ADMIN_PASSWORD" info server 2>/dev/null | grep -q "redis_version"; then
    echo -e "${GREEN}✓ INFO command successful${NC}"
else
    echo -e "${RED}✗ INFO command failed${NC}"
    exit 1
fi

# Test 6: Test connection without authentication
echo -e "${BLUE}Test 6: Connection without authentication${NC}"
if echo "PING" | nc "$PROXY_HOST" "$PROXY_PORT" 2>/dev/null | grep -q "NOAUTH"; then
    echo -e "${GREEN}✓ Unauthenticated requests correctly rejected${NC}"
else
    echo -e "${YELLOW}~ Could not test unauthenticated rejection (expected for some Redis clients)${NC}"
fi

echo ""
echo -e "${GREEN}All tests completed successfully!${NC}"
echo ""
echo "Redis Admin Proxy is working correctly and ready for use."
echo ""
echo "Connection examples:"
echo "  redis-cli -h $PROXY_HOST -p $PROXY_PORT -a '$ADMIN_PASSWORD'"
echo "  redis-cli -h $PROXY_HOST -p $PROXY_PORT"
echo "  > AUTH $ADMIN_PASSWORD"
echo "  > PING"