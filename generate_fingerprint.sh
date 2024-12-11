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

echo "Public Key Extracted Successfully"

# Step 2: Extract the modulus (n) and public exponent (e) in binary format
echo "Step 2: Extracting n (modulus) and e (public exponent) in binary format..."

# Extract modulus and convert to binary
MODULUS_HEX=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -text -noout | grep "modulus:" -A 20 | tail -n +2 | tr -d ' \n:')
MODULUS_BIN=$(echo "$MODULUS_HEX" | xxd -r -p)

# Extract public exponent and convert to binary
PUBLIC_EXPONENT_HEX=$(openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -text -noout | grep "publicExponent" | awk '{print $2}')
PUBLIC_EXPONENT_BIN=$(printf "%x" $PUBLIC_EXPONENT_HEX | xxd -r -p)

# Step 3: Serialize the public key (n, e) as a binary structure
echo "Step 3: Serializing the public key structure..."
PUBLIC_KEY_BIN=$(printf '\x00\x00\x00\x00%s%s' "$(echo -n "$MODULUS_BIN" | xxd -ps -c 256 | wc -c | awk '{print int(($1 + 3) / 4)}')" "$MODULUS_BIN")
PUBLIC_KEY_BIN+=$(printf '\x00\x00\x00\x00%s%s' "$(echo -n "$PUBLIC_EXPONENT_BIN" | xxd -ps -c 256 | wc -c | awk '{print int(($1 + 3) / 4)}')" "$PUBLIC_EXPONENT_BIN")

# Step 4: Compute SHA-1 of the serialized binary structure
echo "Step 4: Computing SHA-1 hash of the serialized public key..."
SHA1_HASH=$(echo -n "$PUBLIC_KEY_BIN" | sha1sum | awk '{print $1}')

# Step 5: Extract the lower 64 bits from SHA-1 as the fingerprint
echo "Step 5: Extracting fingerprint from the SHA-1 hash..."
FINGERPRINT=$(printf '%s' "$SHA1_HASH" | xxd -r -p | tail -c 8 | xxd -p | tr -d '\n')

echo "Fingerprint (Decimal): $FINGERPRINT"

# Step 6: Output the JavaScript code for SERVER_KEYS
echo "Step 6: Generating JavaScript output..."
MODULUS_DECIMAL=$(echo "ibase=16; $MODULUS_HEX" | bc)

cat <<EOF
export const SERVER_KEYS = [
    {
        fingerprint: bigInt('$FINGERPRINT'),
        n: bigInt('$MODULUS_DECIMAL'),
        e: $PUBLIC_EXPONENT_HEX,
    },
]
EOF
