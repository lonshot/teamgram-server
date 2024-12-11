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

# Step 2: Generate the SHA-1 hash of the public key
echo "Step 2: Generating SHA-1 hash of the public key..."
SHA1_HASH=$(echo "$PUBLIC_KEY" | openssl dgst -sha1 | awk '{print $2}')

echo "SHA-1 Hash: $SHA1_HASH"

# Step 3: Convert the SHA-1 hash to decimal and extract the 64 lower-order bits
echo "Step 3: Converting SHA-1 hash to decimal and extracting the lower 64 bits..."
FINGERPRINT=$(echo "ibase=16; ${SHA1_HASH^^}" | bc)

# Extract the lower 64 bits of the fingerprint
FINGERPRINT=$((FINGERPRINT & 0xFFFFFFFFFFFFFFFF))

echo "Fingerprint (Decimal): $FINGERPRINT"

# Step 4: Extract the public key modulus (n) and public exponent (e)
echo "Step 4: Extracting n (modulus) and e (public exponent)..."

# Extract modulus (n) and public exponent (e)
MODULUS=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -text | grep "modulus" -A 20 | tail -n +2 | tr -d '\n' | tr -d ' ')

PUBLIC_EXPONENT=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -text | grep "publicExponent" | awk '{print $2}')

echo "Modulus (n): $MODULUS"
echo "Public Exponent (e): $PUBLIC_EXPONENT"

# Output the result as a JavaScript object
cat <<EOF
export const SERVER_KEYS = [
    {
        fingerprint: bigInt('$FINGERPRINT'),
        n: bigInt('$MODULUS'),
        e: $PUBLIC_EXPONENT,
    },
]
EOF
