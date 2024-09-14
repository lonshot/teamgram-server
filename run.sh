#!/bin/bash

# Print the current date and time for log context
echo "Script started at: $(date)"

# Navigate to the pwm/bin directory and log the output
cd ./pwm/bin
if [ $? -ne 0 ]; then
  echo "Failed to change directory to ./pwm/bin"
  exit 1
fi

# Run the runall2.sh script and log the output
./runall2.sh
if [ $? -ne 0 ]; then
  echo "Failed to execute runall2.sh"
  exit 1
fi

# Return to the previous directory and log the output
cd ../..
if [ $? -ne 0 ]; then
  echo "Failed to change directory to the previous directory"
  exit 1
fi

# Print completion message with timestamp
echo "Script finished at: $(date)"
