#!/bin/bash

# Ensure a private key file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path-to-private-key-file>"
    exit 1
fi

PRIVATE_KEY_FILE="$1"

# Step 1: Extract the public key from the private key
echo "Step 1: Extracting public key from private key file..."
PUBLIC_KEY=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout)

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract public key from private key."
    exit 1
fi

# Step 2: Generate the SHA-1 hash of the public key
echo "Step 2: Generating SHA-1 hash of the public key..."
SHA1_HASH=$(echo -n "$PUBLIC_KEY" | sha1sum | awk '{print $1}')

echo "SHA-1 Hash: $SHA1_HASH"
echo "----------------------------------------"

# Step 3: Extract the first 8 bytes (16 hex digits) of the SHA-1 hash
FIRST_8_BYTES=${SHA1_HASH:0:16}

# Step 4: Convert the first 8 bytes (16 hex characters) from hexadecimal to decimal
FINGERPRINT_DECIMAL=$(echo "ibase=16; $FIRST_8_BYTES" | bc)

# Check if bc returned an error
if [ $? -ne 0 ]; then
    echo "Error: Failed to convert hexadecimal hash to decimal."
    exit 1
fi

echo "Fingerprint (Decimal): $FINGERPRINT_DECIMAL"
echo "----------------------------------------"

# Step 5: Extract the modulus (n) from the public key (using openssl to extract it)
MODULUS=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -text | grep 'Modulus' | awk '{print $2}')

# Step 6: Output the JavaScript configuration
echo "export const SERVER_KEYS = ["
echo "    {"
echo "        fingerprint: $FINGERPRINT_DECIMAL,"
echo "        n: bigInt('$MODULUS'),"
echo "        e: 65537,"
echo "    },"
echo "]"
