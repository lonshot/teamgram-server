#!/bin/bash

# Enable debugging for step-by-step output
set -euo pipefail

echo "Starting RSA Fingerprint Generation"

# Check if PRIVATE_KEY_PATH is provided as a parameter
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <path-to-private-key>"
  exit 1
fi

PRIVATE_KEY_PATH="$1"
echo "Private key path provided: $PRIVATE_KEY_PATH"

# Check if the private key exists
if [[ ! -f "$PRIVATE_KEY_PATH" ]]; then
  echo "Error: Private key file not found at $PRIVATE_KEY_PATH"
  exit 1
fi

# Step 1: Extract modulus (n) from the private key
echo "Step 1: Extracting modulus (n)"
modulus_hex=$(openssl rsa -in "$PRIVATE_KEY_PATH" -noout -modulus | sed 's/Modulus=//')
modulus_decimal=$(echo "ibase=16; $modulus_hex" | bc)
echo "Modulus (decimal): $modulus_decimal"

# Step 2: Extract exponent (e) from the private key
echo "Step 2: Extracting public exponent (e)"
exponent=$(openssl rsa -in "$PRIVATE_KEY_PATH" -text -noout | grep "publicExponent" | awk '{print $2}' | tr -d '()')
echo "Public Exponent: $exponent"

# Step 3: Convert modulus and exponent to binary
echo "Step 3: Converting modulus and exponent to binary"
modulus_bin=$(echo "$modulus_hex" | xxd -r -p)
exponent_bin=$(printf "%x" "$exponent" | xxd -r -p)

# Step 4: Construct TL-serialized public key
echo "Step 4: Constructing TL-serialized public key"
public_key_bin=$(echo -n -e "\x00${modulus_bin}${exponent_bin}")

# Step 5: Calculate SHA1 hash of the public key
echo "Step 5: Calculating SHA1 hash of the public key"
fingerprint_sha1=$(echo -n "$public_key_bin" | sha1sum | awk '{print $1}')
echo "SHA1 Hash: $fingerprint_sha1"

# Step 6: Extract fingerprint (last 8 bytes of the SHA1 hash, interpreted as signed 64-bit integer)
echo "Step 6: Extracting fingerprint"
fingerprint=$(printf "%d" $((0x${fingerprint_sha1: -16})))
echo "Fingerprint: $fingerprint"

# Step 7: Format the output
echo "Step 7: Formatting output"
echo "{
    fingerprint: bigInt('$fingerprint'),
    n: bigInt(
        '$modulus_decimal',
    ),
    e: $exponent,
}"
