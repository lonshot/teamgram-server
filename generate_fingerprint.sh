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

# Step 2: Extract the modulus (n) and public exponent (e) from the public key
echo "Step 2: Extracting modulus (n) and public exponent (e)..."
MODULUS=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -text | grep "Modulus" | awk '{print $2}')
EXPONENT=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -text | grep "publicExponent" | awk '{print $2}')

echo "Modulus (n): $MODULUS"
echo "Public Exponent (e): $EXPONENT"
echo "----------------------------------------"

# Step 3: Generate the fingerprint of the public key using SHA-1
echo "Step 3: Generating SHA-1 fingerprint of the public key..."
FINGERPRINT=$(echo -n "$PUBLIC_KEY" | sha1sum | awk '{print $1}')

echo "SHA-1 Fingerprint: $FINGERPRINT"
echo "----------------------------------------"

# Step 4: Convert the SHA-1 fingerprint to decimal
echo "Step 4: Converting SHA-1 fingerprint to decimal..."
DECIMAL_FINGERPRINT=$(echo "ibase=16; ${FINGERPRINT^^}" | bc)

echo "Fingerprint (Decimal): $DECIMAL_FINGERPRINT"

# Output the result in the requested format
echo "export const SERVER_KEYS = ["
echo "    {"
echo "        fingerprint: bigInt('$DECIMAL_FINGERPRINT'),"
echo "        n: bigInt('$MODULUS'),"
echo "        e: $EXPONENT,"
echo "    },"
echo "]"
