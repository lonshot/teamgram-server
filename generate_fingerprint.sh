#!/bin/bash

# Input: Path to the RSA private key file (PEM format)
PRIVATE_KEY_FILE="$1"

# Check if the private key file is provided
if [ -z "$PRIVATE_KEY_FILE" ]; then
  echo "Usage: $0 <private-key-file>"
  exit 1
fi

# Extract the public key from the private key
PUBLIC_KEY=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout 2>/dev/null)

# Check if public key extraction was successful
if [ $? -ne 0 ]; then
  echo "Failed to extract public key from private key."
  exit 1
fi

# Calculate the SHA-1 hash of the public key (in binary format)
PUBLIC_KEY_HASH=$(echo "$PUBLIC_KEY" | openssl sha1 -binary)

# Convert the SHA-1 hash (binary) to a hexadecimal value
HEX_HASH=$(echo "$PUBLIC_KEY_HASH" | xxd -p | tr -d '\n')

# Check if the conversion is successful
if [ -z "$HEX_HASH" ]; then
  echo "Error: Unable to generate the hash."
  exit 1
fi

# Convert the hexadecimal hash to a decimal number
DECIMAL_HASH=$(echo "ibase=16; $HEX_HASH" | bc)

# Check if the decimal conversion was successful
if [ $? -ne 0 ]; then
  echo "Error: Unable to convert hexadecimal hash to decimal."
  exit 1
fi

# Output the fingerprint in the decimal format
echo "Fingerprint (Decimal): $DECIMAL_HASH"
