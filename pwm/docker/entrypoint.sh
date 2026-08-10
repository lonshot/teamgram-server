#!/bin/bash
# if [ ! -n "$PWM_HOST" ]; then
#   echo ">>> Plase set environment variable PWM_HOST to your own server IP. <<<"
#   exit 1
# fi
 
export PWM_HOST=${PWM_HOST:-"0.0.0.0"}
export ETCD_URL=${ETCD_URL:-"etcd:2379"}
export REDIS_HOST=${REDIS_HOST:-"redis:6379"}
export KAFKA_HOST=${KAFKA_HOST:-"kafka:9092"}
export MYSQL_URI=${MYSQL_URI:-"pwm:pass123456a@tcp(mysql:3306)/pwm?charset=utf8mb4"}
export MINIO_URI=${MINIO_URI:-"minio:9000"}
export MINIO_KEY=${MINIO_KEY:-"pwm-dotnet-api"}
export MINIO_SECRET=${MINIO_SECRET:-"pwm@dotnet2025!secure"}
export MINIO_SSL=${MINIO_SSL:-"false"}
#export MTZ=${MTZ:-"Asia%2FTehran"}

# create configs from config templates.
createConfigs() {
  CONFIG_TARGET_DIR=/app/etc2
  CONFIG_TEMPLATES_DIR=/app/etc
  escapeSedReplacement() {
    printf '%s' "$1" | sed 's/[&|\\]/\\&/g'
  }
  ETCD_URL_ESCAPED=$(escapeSedReplacement "$ETCD_URL")
  REDIS_HOST_ESCAPED=$(escapeSedReplacement "$REDIS_HOST")
  KAFKA_HOST_ESCAPED=$(escapeSedReplacement "$KAFKA_HOST")
  MYSQL_URI_ESCAPED=$(escapeSedReplacement "$MYSQL_URI")
  MINIO_URI_ESCAPED=$(escapeSedReplacement "$MINIO_URI")
  MINIO_KEY_ESCAPED=$(escapeSedReplacement "$MINIO_KEY")
  MINIO_SECRET_ESCAPED=$(escapeSedReplacement "$MINIO_SECRET")
  PWM_WEB_URL_ESCAPED=$(escapeSedReplacement "${PWM_WEB_URL:-http://web:8080}")
  for file in `ls $CONFIG_TEMPLATES_DIR`; do
    cat $CONFIG_TEMPLATES_DIR/$file \
      | sed 's#ListenOn: 127.0.0.1#ListenOn: '"$PWM_HOST"'#g' \
      | sed "s|127.0.0.1:2379|$ETCD_URL_ESCAPED|g" \
      | sed "s|127.0.0.1:6379|$REDIS_HOST_ESCAPED|g" \
      | sed "s|localhost:6379|$REDIS_HOST_ESCAPED|g" \
      | sed "s|root:@tcp(127.0.0.1:3306)/pwm?charset=utf8mb4|$MYSQL_URI_ESCAPED|g" \
      | sed 's|AccessKeyID: pwm-dotnet-api|AccessKeyID: '"$MINIO_KEY_ESCAPED"'|g' \
      | sed 's|SecretAccessKey: pwm@dotnet2025!secure|SecretAccessKey: '"$MINIO_SECRET_ESCAPED"'|g' \
      | sed 's#UseSSL: false#UseSSL: '"$MINIO_SSL"'#g' \
      | sed "s|localhost:9000|$MINIO_URI_ESCAPED|g" \
      | sed "s|127.0.0.1:9092|$KAFKA_HOST_ESCAPED|g" \
      | sed "s|http://pwm_web_server:8080|$PWM_WEB_URL_ESCAPED|g" \
      | cat > $CONFIG_TARGET_DIR/$file
  done
}

createConfigs

cd /app/bin
chmod +x ./runall.sh
./runall.sh

tail -f /dev/null
