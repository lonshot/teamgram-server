#!/bin/bash

# Check if a private key file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <private_key_file>"
    exit 1
fi

PRIVATE_KEY_FILE=$1

# Step 1: Extract the public key from the private key
echo "Step 1: Extracting public key from private key..."
PUBLIC_KEY=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -outform PEM)

if [ $? -ne 0 ]; then
    echo "Error extracting public key"
    exit 1
fi

echo "Public Key Extracted Successfully:"
echo "$PUBLIC_KEY"

# Step 2: Generate the SHA-1 hash of the public key
echo "Step 2: Generating SHA-1 hash of the public key..."
SHA1_HASH=$(echo "$PUBLIC_KEY" | openssl dgst -sha1 | awk '{print $2}')

echo "SHA-1 Hash: $SHA1_HASH"

# Step 3: Extract the 64 lower-order bits of the SHA-1 hash
# Convert the SHA-1 hash from hex to decimal and then extract the lower 64 bits
echo "Step 3: Converting SHA-1 hash to decimal and extracting the lower 64 bits..."
FINGERPRINT=$(echo "ibase=16; ${SHA1_HASH^^}" | bc)

# Take only the lower 64 bits
FINGERPRINT=$((FINGERPRINT & 0xFFFFFFFFFFFFFFFF))

echo "Fingerprint (Decimal): $FINGERPRINT"
