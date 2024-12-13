#!/usr/bin/env bash

# Directory for configs
CONFIG_DIR="../etc2"
LOG_DIR="../logs"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to run a service in detached mode and tail the logs
run_service() {
  local service_name=$1
  local config_file=$2

  echo "Starting $service_name ..."

  # Start the service in the background and redirect logs to a file
  ./$service_name -f="$CONFIG_DIR/$config_file" > "$LOG_DIR/$service_name.log" 2>&1 &

  # Check if the service started successfully
  if [ $? -eq 0 ]; then
    echo "$service_name started successfully. Logs:"
    # Tail the log file to show output in the console
    tail -f "$LOG_DIR/$service_name.log" &
  else
    echo "Error starting $service_name."
  fi

  sleep 1
}

# Run services with their respective config files
run_service "idgen" "idgen.yaml"
run_service "status" "status.yaml"
run_service "authsession" "authsession.yaml"
run_service "dfs" "dfs.yaml"
run_service "media" "media.yaml"
run_service "biz" "biz.yaml"
run_service "msg" "msg.yaml"
run_service "sync" "sync.yaml"
run_service "bff" "bff.yaml"

# Add a longer delay for the "bff" service
sleep 5

run_service "session" "session.yaml"

# Optional services - uncomment if needed
# run_service "gateway" "gateway.yaml"
run_service "httpserver" "httpserver.yaml"

run_service "gnetway" "gnetway.yaml"
