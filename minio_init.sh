#!/bin/bash

# Wait for MinIO to be ready
echo "Waiting for MinIO to start..."
sleep 30

# Configure MinIO client with root credentials
echo "Setting up MinIO alias..."
mc alias set minio http://minio:9000 admin pwm@admin2025!

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
  --access-key "pwm-dotnet-api" \
  --secret-key "pwm@dotnet2025!secure" \
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
mc admin policy attach minio pwm-dotnet-policy --user pwm-dotnet-api

# Create additional user for console access (optional - for team members)
echo "Creating additional console user..."
mc admin user add minio pwm-user pwm@user2025!
mc admin policy attach minio readwrite --user pwm-user

echo "MinIO initialization completed!"
echo "Root Console Login: admin / pwm@admin2025!"
echo ".NET API Access Key: pwm-dotnet-api"
echo ".NET API Secret Key: pwm@dotnet2025!secure"
echo "Additional User Login: pwm-user / pwm@user2025!"

exit 0
