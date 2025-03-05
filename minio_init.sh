#!/bin/bash
sleep 30

# Set MinIO alias
mc alias set minio http://minio:9000 minio pwm1234aa

# Create required buckets
mc mb minio/documents
mc mb minio/encryptedfiles
mc mb minio/photos
mc mb minio/videos
mc mb minio/upload
mc mb minio/thumbnails

echo "All required buckets created successfully."

# Generate a new access key and secret key
NEW_ACCESS_KEY=G19jgkWDXcPXibXuhMap
NEW_SECRET_KEY=GwyOIMFNpjZHhXDfEFWOqVgzwhIHIeaEzey48vDh
USER_NAME="appuser"

# Create a new MinIO user
mc admin user add minio "$NEW_ACCESS_KEY" "$NEW_SECRET_KEY"

# Assign a readwrite policy to the new user
mc admin policy attach minio readwrite --user "$NEW_ACCESS_KEY"

# Output generated credentials
echo "New MinIO user created:"
echo "Access Key: $NEW_ACCESS_KEY"
echo "Secret Key: $NEW_SECRET_KEY"

# Save credentials to a file for reference
echo "Minio Credentials:" > /data/minio_new_user_credentials.txt
echo "Endpoint: minio:9000" >> /data/minio_new_user_credentials.txt
echo "AccessKey: $NEW_ACCESS_KEY" >> /data/minio_new_user_credentials.txt
echo "SecretKey: $NEW_SECRET_KEY" >> /data/minio_new_user_credentials.txt
echo "BucketUploadName: upload" >> /data/minio_new_user_credentials.txt
echo "BucketThumbnailName: thumbnails" >> /data/minio_new_user_credentials.txt
echo "BucketPhotoName: photos" >> /data/minio_new_user_credentials.txt

echo "New credentials saved in /data/minio_new_user_credentials.txt"
exit
