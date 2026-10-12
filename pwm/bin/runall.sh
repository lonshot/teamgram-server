#!/usr/bin/env bash
set -u

BIN_DIR=${PWM_BIN_DIR:-/app/bin}
CONFIG_DIR=${PWM_CONFIG_DIR:-/app/etc2}
LOG_DIR=${PWM_LOG_DIR:-/app/logs}
RUN_DIR=${PWM_RUN_DIR:-/app/run/services}
STARTUP_TIMEOUT=${PWM_STARTUP_TIMEOUT:-300}
SERVICES=(idgen status authsession dfs media biz msg sync bff session httpserver gnetway)
SUPERVISORS=()

tcp_ready() {
  timeout 2 bash -c 'exec 3<>/dev/tcp/$1/$2' _ "$1" "$2" >/dev/null 2>&1
}

service_port() {
  # Generated configs contain actual ports. Only httpserver nests its port.
  awk '/^ListenOn:/ {sub(/\r$/, "", $2); sub(/^.*:/, "", $2); print $2; exit}
       /^[[:space:]]+Port:/ && !port {port=$2; sub(/\r$/, "", port)}
       END {if (port) print port}' "$CONFIG_DIR/$1.yaml" | head -n 1
}

service_ready() {
  local service=$1 pid
  pid=$(cat "$RUN_DIR/$service.pid" 2>/dev/null) || return 1
  kill -0 "$pid" 2>/dev/null || return 1
  # sync is a Kafka consumer: its configured gRPC server is disabled in main.
  # It has no TCP listener. Monitor the actual process instead.
  [ "$service" = sync ] || tcp_ready 127.0.0.1 "$(service_port "$service")"
}

if [ "${1:-}" = --health ]; then
  for service in "${SERVICES[@]}"; do
    service_ready "$service" || exit 1
  done
  exit 0
fi

mkdir -p "$LOG_DIR" "$RUN_DIR"
chmod 700 "$RUN_DIR"
cd "$BIN_DIR" || exit 1

cleanup() {
  trap - EXIT
  for pid in "${SUPERVISORS[@]}"; do kill -TERM "$pid" 2>/dev/null || true; done
  for pid in "${SUPERVISORS[@]}"; do wait "$pid" 2>/dev/null || true; done
}
trap cleanup EXIT
trap 'exit 0' TERM INT

wait_endpoint() {
  local name=$1 host=$2 port=$3 started=$SECONDS
  until tcp_ready "$host" "$port"; do
    if (( SECONDS - started >= STARTUP_TIMEOUT )); then
      echo "Startup timed out waiting for $name" >&2
      return 1
    fi
    sleep 1
  done
  echo "$name ready"
}

# TCP readiness replaces fixed sleeps. Supervisors also retry when a broker
# accepts TCP before its protocol is ready and causes a child to exit.
mysql_endpoint=${MYSQL_URI:-tcp(mysql:3306)}
mysql_endpoint=${mysql_endpoint#*tcp(}
mysql_endpoint=${mysql_endpoint%%)*}
dependency_endpoints=${PWM_DEPENDENCY_ENDPOINTS:-"etcd=${ETCD_URL:-etcd:2379} redis=${REDIS_HOST:-redis:6379} mysql=$mysql_endpoint kafka=${KAFKA_HOST:-kafka:9092} minio=${MINIO_URI:-minio:9000}"}
for dependency in $dependency_endpoints; do
  name=${dependency%%=*}
  endpoint=${dependency#*=}
  endpoint=${endpoint#http://}; endpoint=${endpoint#https://}
  wait_endpoint "$name" "${endpoint%:*}" "${endpoint##*:}" || exit 1
done

supervise() {
  local service=$1 child='' delay=1 started status
  trap - EXIT
  trap 'if [ -n "$child" ]; then kill -TERM "$child" 2>/dev/null || true; wait "$child" 2>/dev/null || true; fi; rm -f "$RUN_DIR/$service.pid"; exit 0' TERM INT
  while true; do
    started=$SECONDS
    "$BIN_DIR/$service" -f="$CONFIG_DIR/$service.yaml" >> "$LOG_DIR/$service.log" 2>&1 &
    child=$!
    printf '%s\n' "$child" > "$RUN_DIR/$service.pid"
    wait "$child"
    status=$?
    child=''
    rm -f "$RUN_DIR/$service.pid"
    if (( SECONDS - started >= 30 )); then delay=1; fi
    echo "$service exited ($status); retrying in ${delay}s" >&2
    sleep "$delay" &
    child=$!
    wait "$child"
    child=''
    if (( delay < 10 )); then delay=$((delay + 1)); fi
  done
}

for service in "${SERVICES[@]}"; do
  [ -x "$BIN_DIR/$service" ] && [ -r "$CONFIG_DIR/$service.yaml" ] || {
    echo "Missing binary or generated configuration for $service" >&2
    exit 1
  }
  supervise "$service" &
  SUPERVISORS+=("$!")
  # Bring up shared RPC foundations first. The interface/messenger services
  # discover each other, so launch that group before waiting on its listeners.
  case "$service" in
    idgen|status|authsession|dfs|media|biz)
      wait_endpoint "$service" 127.0.0.1 "$(service_port "$service")" || exit 1 ;;
  esac
done

for service in "${SERVICES[@]}"; do
  if [ "$service" = sync ]; then
    started=$SECONDS
    until service_ready "$service"; do
      (( SECONDS - started < STARTUP_TIMEOUT )) || exit 1
      sleep 1
    done
    echo "sync consumer started"
  else
    wait_endpoint "$service" 127.0.0.1 "$(service_port "$service")" || exit 1
  fi
done
echo "All 12 PWM services ready"

# Keep PID 1 attached to supervisors rather than an unrelated tail process.
while true; do
  for pid in "${SUPERVISORS[@]}"; do kill -0 "$pid" 2>/dev/null || exit 1; done
  sleep 2 &
  wait $!
done
