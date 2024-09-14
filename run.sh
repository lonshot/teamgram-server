#!/bin/bash

# Print the current date and time for log context
echo "Script started at: $(date)"

docker compose down
docker compose up -d

# Print completion message with timestamp
echo "Script finished at: $(date)"

docker compose logs --tail 100 -f
