# MinIO credentials

Supply these values outside Git:

- `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD` for administration.
- `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` for application access.
- `MINIO_USER_PASSWORD` if using the optional example user setup.

`minio_init.sh` reads these environment variables and requires values before
creating accounts. Do not commit the runtime environment file. Match the
credentials supplied to the container entrypoint and MinIO service.
