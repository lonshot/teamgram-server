#!/bin/bash

# Provide the private key file path as input
PRIVATE_KEY_PATH="$1"

# Log the starting process
echo "Starting RSA Fingerprint Generation"
echo "Private key path provided: $PRIVATE_KEY_PATH"

# Step 1: Extract the modulus (n) and exponent (e) using openssl
echo "Step 1: Extracting modulus (n)"
modulus=$(openssl rsa -in "$PRIVATE_KEY_PATH" -noout -modulus | sed 's/Modulus=//')

# Log modulus
echo "Modulus (hex): $modulus"

# Step 2: Extract the public exponent (e), which is commonly 65537 for most keys
echo "Step 2: Extracting public exponent (e)"
exponent=$(openssl rsa -in "$PRIVATE_KEY_PATH" -noout -text | grep "publicExponent" | sed 's/.*=//')

# Log exponent
echo "Public Exponent: $exponent"

# Step 3: Convert modulus and exponent to binary
echo "Step 3: Converting modulus and exponent to binary"
modulus_bin=$(echo "$modulus" | xxd -r -p | base64)
exponent_bin=$(echo "$exponent" | xxd -r -p | base64)

# Log conversion to binary
echo "Modulus (binary): $modulus_bin"
echo "Exponent (binary): $exponent_bin"

# Step 4: Construct the TL-serialized public key
# For this, we can use openssl or a script to serialize the public key in the required format
echo "Step 4: Constructing TL-serialized public key"
# Assuming a function or openssl command can help with TL serialization, you may need to serialize manually here

# For simplicity, assume serialized public key (in base64)
public_key_serialized="your_serialized_public_key_here"

# Step 5: Calculate the SHA1 hash of the public key
echo "Step 5: Calculating SHA1 hash of the public key"
sha1_hash=$(echo -n "$public_key_serialized" | sha1sum | awk '{print $1}')

# Log the SHA1 hash
echo "SHA1 Hash: $sha1_hash"

# Step 6: Extract fingerprint (last 64 bits of the SHA1 hash)
echo "Step 6: Extracting fingerprint"
fingerprint_hex=${sha1_hash:12:16} # Last 64 bits as hexadecimal (from position 12 to 16)
fingerprint_decimal=$(echo "ibase=16; $fingerprint_hex" | bc)

# Log fingerprint
echo "Fingerprint: $fingerprint_decimal"

# Optional: Convert fingerprint to a positive number if needed
if [[ "$fingerprint_decimal" -lt 0 ]]; then
    fingerprint_decimal=$(($fingerprint_decimal * -1))
    echo "Converted fingerprint to positive: $fingerprint_decimal"
fi

# Final output in required format
echo "{
    fingerprint: bigInt('$fingerprint_decimal'),
    n: bigInt('$modulus'),
    e: $exponent
}"
