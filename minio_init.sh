#!/bin/bash
sleep 30
mc alias set minio http://minio:9000 minio pwm1234aa
mc mb minio/documents
mc mb minio/encryptedfiles
mc mb minio/photos
mc mb minio/videos
exit
