#!/bin/bash

# Enable debugging for step-by-step output
set -euo pipefail

echo "Starting RSA Fingerprint Generation"

# File path to the RSA private key
PRIVATE_KEY_PATH="private_key.pem"
echo "Private key path: $PRIVATE_KEY_PATH"

# Check if the private key exists
if [[ ! -f "$PRIVATE_KEY_PATH" ]]; then
  echo "Error: Private key file not found at $PRIVATE_KEY_PATH"
  exit 1
fi

# Step 1: Extract modulus (n) from the private key
echo "Step 1: Extracting modulus (n)"
modulus=$(openssl rsa -in "$PRIVATE_KEY_PATH" -noout -modulus | sed 's/Modulus=//')
echo "Modulus (hex): $modulus"

# Step 2: Extract public exponent (e) from the private key
echo "Step 2: Extracting public exponent (e)"
exponent=$(openssl rsa -in "$PRIVATE_KEY_PATH" -noout -text | grep publicExponent | awk '{print $2}')
echo "Exponent: $exponent"

# Step 3: Convert modulus to binary
echo "Step 3: Converting modulus to binary"
modulus_bin=$(echo "$modulus" | xxd -r -p)
modulus_bin_size=$(echo -n "$modulus_bin" | wc -c)
echo "Modulus (binary size): $modulus_bin_size bytes"

# Step 4: Convert exponent to binary
echo "Step 4: Converting exponent to binary"
exponent_bin=$(printf '%08x' "$exponent" | xxd -r -p)
exponent_bin_size=$(echo -n "$exponent_bin" | wc -c)
echo "Exponent (binary size): $exponent_bin_size bytes"

# Step 5: Serialize the TL structure
echo "Step 5: Serializing TL structure"
tmp_file=$(mktemp)
echo -n -e "\x00" > "$tmp_file"  # Placeholder for type (optional in TL)
echo -n -e "$modulus_bin" >> "$tmp_file"
echo -n -e "$exponent_bin" >> "$tmp_file"
serialized_size=$(wc -c < "$tmp_file")
echo "Serialized data size: $serialized_size bytes"
echo "Serialized data (hex): $(xxd -p "$tmp_file")"

# Step 6: Compute SHA1 hash
echo "Step 6: Computing SHA1 hash"
key_sha1=$(sha1sum "$tmp_file" | awk '{print $1}')
echo "SHA1 hash: $key_sha1"

# Step 7: Extract the last 8 bytes for fingerprint
echo "Step 7: Extracting last 8 bytes of SHA1 hash"
fingerprint_last_8=${key_sha1:32}
echo "Last 8 bytes (hex): $fingerprint_last_8"

# Step 8: Convert to int64
echo "Step 8: Converting to int64 fingerprint"
fingerprint_int64=$((0x$fingerprint_last_8))
echo "Fingerprint (int64): $fingerprint_int64"

# Step 9: Cleanup temporary file
echo "Step 9: Cleaning up"
rm "$tmp_file"
echo "Temporary file removed."

echo "RSA Fingerprint Generation Completed Successfully."
