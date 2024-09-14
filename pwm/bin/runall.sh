#!/usr/bin/env bash

# Directory for configs
CONFIG_DIR="../etc2"

# Function to run a service
run_service() {
  local service_name=$1
  local config_file=$2

  echo "Starting $service_name ..."
  ./$service_name -f="$CONFIG_DIR/$config_file"  # No redirection, logs will appear in the console

  # Check if the service started successfully
  if [ $? -eq 0 ]; then
    echo "$service_name started successfully."
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
# run_service "httpserver" "httpserver.yaml"

run_service "gnetway" "../etc/gnetway.yaml"
