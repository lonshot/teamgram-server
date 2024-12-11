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

echo "Public Key Extracted Successfully:"
echo "$PUBLIC_KEY"
echo "----------------------------------------"

# Step 2: Generate SHA-1 hash of the public key
echo "Step 2: Generating SHA-1 hash of the public key..."
SHA1_HASH=$(echo -n "$PUBLIC_KEY" | sha1sum | awk '{print $1}')

echo "SHA-1 Hash Generated:"
echo "$SHA1_HASH"
echo "----------------------------------------"

# Step 3: Convert the SHA-1 hash to a decimal value
echo "Step 3: Converting SHA-1 hash to decimal..."
DECIMAL_FINGERPRINT=$(echo "ibase=16; $SHA1_HASH" | bc)

echo "Fingerprint (Decimal): $DECIMAL_FINGERPRINT"
