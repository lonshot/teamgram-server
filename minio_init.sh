#!/bin/bash

# Wait for MinIO to be ready
echo "Waiting for MinIO to start..."
sleep 30

# Configure MinIO client with root credentials
echo "Setting up MinIO alias..."
mc alias set minio http://minio:9000 "${MINIO_ROOT_USER:?set MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD:?set MINIO_ROOT_PASSWORD}"

# Create buckets
echo "Creating buckets..."
mc mb minio/documents --ignore-existing
mc mb minio/encryptedfiles --ignore-existing  
mc mb minio/photos --ignore-existing
mc mb minio/videos --ignore-existing
mc mb minio/thumbnails --ignore-existing
mc mb minio/upload --ignore-existing

# Create service account for .NET server
echo "Creating service account for .NET server..."
mc admin user svcacct add minio admin \
  --access-key "${MINIO_ACCESS_KEY:?set MINIO_ACCESS_KEY}" \
  --secret-key "${MINIO_SECRET_KEY:?set MINIO_SECRET_KEY}" \
  --name "PWM .NET Server API" \
  --description "Service account for PWM .NET server API access"

# Create policy for .NET server access
echo "Creating policy for .NET server..."
cat > /tmp/pwm-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::*"
      ]
    }
  ]
}
EOF

mc admin policy create minio pwm-dotnet-policy /tmp/pwm-policy.json

# Apply policy to service account
mc admin policy attach minio pwm-dotnet-policy --user CHANGE_ME

# Create additional user for console access (optional - for team members)
echo "Creating additional console user..."
mc admin user add minio pwm-user "${MINIO_USER_PASSWORD:?set MINIO_USER_PASSWORD}"
mc admin policy attach minio readwrite --user pwm-user

echo "MinIO initialization completed!"
echo "Root Console Login: admin / CHANGE_ME"
echo ".NET API Access Key: CHANGE_ME"
echo ".NET API Secret Key: CHANGE_ME"
echo "Additional User Login: pwm-user / CHANGE_ME"

exit 0
