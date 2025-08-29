# MinIO Access Credentials

## Root Administrator Access (Console Login)
- **Username**: `admin`
- **Password**: `pwm@admin2025!`
- **Console URL**: `http://your-server:9001` or `https://your-domain:9001`
- **Purpose**: Full administrative access to MinIO console

## .NET Server API Access (Service Account)
- **Access Key**: `pwm-dotnet-api`
- **Secret Key**: `pwm@dotnet2025!secure`
- **Endpoint**: `http://your-server:9000` or `https://your-domain:9000`
- **Purpose**: Programmatic access for PWM .NET server

## Additional Console User (Optional)
- **Username**: `pwm-user`
- **Password**: `pwm@user2025!`
- **Purpose**: Limited access for team members

## Buckets Created
- `documents` - Document storage
- `encryptedfiles` - Encrypted file storage
- `photos` - Photo storage
- `videos` - Video storage
- `thumbnails` - Thumbnail storage
- `upload` - Temporary upload storage

## Policy Details
The `.NET server service account` has the following permissions:
- `s3:GetObject` - Download files
- `s3:PutObject` - Upload files
- `s3:DeleteObject` - Delete files
- `s3:ListBucket` - List bucket contents

## Usage in .NET Application
```csharp
var minio = new MinioClient()
    .WithEndpoint("your-server:9000")
    .WithCredentials("pwm-dotnet-api", "pwm@dotnet2025!secure")
    .WithSSL(false) // Set to true if using HTTPS
    .Build();
```

## Security Notes
- Change all passwords in production
- Use HTTPS in production
- Regularly rotate service account keys
- Monitor access logs
