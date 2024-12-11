#!/bin/bash

# Input: Path to the RSA private key file (PEM format)
PRIVATE_KEY_FILE="$1"

# Check if the private key file is provided
if [ -z "$PRIVATE_KEY_FILE" ]; then
  echo "Usage: $0 <private-key-file>"
  exit 1
fi

# Check if the provided private key file exists
if [ ! -f "$PRIVATE_KEY_FILE" ]; then
  echo "Error: Private key file does not exist: $PRIVATE_KEY_FILE"
  exit 1
fi

echo "Step 1: Extracting public key from private key file..."

# Extract the public key from the private key
PUBLIC_KEY=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout 2>&1)

# Check if public key extraction was successful
if [ $? -ne 0 ]; then
  echo "Failed to extract public key. OpenSSL output:"
  echo "$PUBLIC_KEY"
  exit 1
fi

echo "Public Key Extracted Successfully:"
echo "$PUBLIC_KEY"
echo "----------------------------------------"

echo "Step 2: Generating SHA-1 hash of the public key..."

# Calculate the SHA-1 hash of the public key (in binary format)
PUBLIC_KEY_HASH=$(echo "$PUBLIC_KEY" | openssl sha1 -binary 2>&1)

# Check if SHA-1 hash generation was successful
if [ $? -ne 0 ]; then
  echo "Failed to generate SHA-1 hash. OpenSSL output:"
  echo "$PUBLIC_KEY_HASH"
  exit 1
fi

echo "SHA-1 Hash Generated (binary):"
echo "$PUBLIC_KEY_HASH"
echo "----------------------------------------"

echo "Step 3: Converting SHA-1 hash to hexadecimal..."

# Convert the SHA-1 hash (binary) to a hexadecimal value
HEX_HASH=$(echo "$PUBLIC_KEY_HASH" | xxd -p | tr -d '\n' 2>&1)

# Check if hexadecimal conversion was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to convert binary hash to hexadecimal."
  echo "$HEX_HASH"
  exit 1
fi

echo "Hexadecimal Hash:"
echo "$HEX_HASH"
echo "----------------------------------------"

echo "Step 4: Converting hexadecimal hash to decimal..."

# Convert the hexadecimal hash to a decimal number
DECIMAL_HASH=$(echo "ibase=16; $HEX_HASH" | bc 2>&1)

# Check if the conversion to decimal was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to convert hexadecimal to decimal."
  echo "$DECIMAL_HASH"
  exit 1
fi

echo "Fingerprint (Decimal): $DECIMAL_HASH"
