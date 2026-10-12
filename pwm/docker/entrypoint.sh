#!/bin/bash
set -e
umask 077
# if [ ! -n "$PWM_HOST" ]; then
#   echo ">>> Plase set environment variable PWM_HOST to your own server IP. <<<"
#   exit 1
# fi
 
export PWM_HOST=${PWM_HOST:-"0.0.0.0"}
export ETCD_URL=${ETCD_URL:-"etcd:2379"}
export REDIS_HOST=${REDIS_HOST:-"redis:6379"}
export KAFKA_HOST=${KAFKA_HOST:-"kafka:9092"}
export MYSQL_URI=${MYSQL_URI:-"pwm:CHANGE_ME@tcp(mysql:3306)/pwm?charset=utf8mb4"}
export MINIO_URI=${MINIO_URI:-"minio:9000"}
export MINIO_KEY=${MINIO_KEY:-"CHANGE_ME"}
export MINIO_SECRET=${MINIO_SECRET:-"CHANGE_ME"}
export MINIO_SSL=${MINIO_SSL:-"false"}
export PWM_ENVIRONMENT=${PWM_ENVIRONMENT:-"Development"}
export PWM_VERIFY_PROVIDER=${PWM_VERIFY_PROVIDER:-"me"}
export PWM_VERIFY_TIMEOUT=${PWM_VERIFY_TIMEOUT:-"20s"}
export PWM_AUTO_VERIFY_ENABLED=${PWM_AUTO_VERIFY_ENABLED:-"false"}
export PWM_OTP_BYPASS_ENABLED=${PWM_OTP_BYPASS_ENABLED:-"false"}
export PWM_OTP_BYPASS_ALLOW_PRODUCTION=${PWM_OTP_BYPASS_ALLOW_PRODUCTION:-"false"}
export PWM_OTP_BYPASS_CODE=${PWM_OTP_BYPASS_CODE:-""}
export PWM_BFF_PORT=${PWM_BFF_PORT:-"20010"}
export PWM_HTTP_PORT=${PWM_HTTP_PORT:-"8801"}
#export MTZ=${MTZ:-"Asia%2FTehran"}

# create configs from config templates.
createConfigs() {
  CONFIG_TARGET_DIR=/app/etc2
  CONFIG_TEMPLATES_DIR=/app/etc
  mkdir -p "$CONFIG_TARGET_DIR"
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
  PWM_ENVIRONMENT_ESCAPED=$(escapeSedReplacement "$PWM_ENVIRONMENT")
  PWM_VERIFY_PROVIDER_ESCAPED=$(escapeSedReplacement "$PWM_VERIFY_PROVIDER")
  PWM_VERIFY_TIMEOUT_ESCAPED=$(escapeSedReplacement "$PWM_VERIFY_TIMEOUT")
  PWM_OTP_BYPASS_CODE_ESCAPED=$(escapeSedReplacement "$PWM_OTP_BYPASS_CODE")
  for file in `ls $CONFIG_TEMPLATES_DIR`; do
    cat $CONFIG_TEMPLATES_DIR/$file \
      | sed 's#ListenOn: 127.0.0.1#ListenOn: '"$PWM_HOST"'#g' \
      | sed "s|127.0.0.1:2379|$ETCD_URL_ESCAPED|g" \
      | sed "s|127.0.0.1:6379|$REDIS_HOST_ESCAPED|g" \
      | sed "s|localhost:6379|$REDIS_HOST_ESCAPED|g" \
      | sed "s|root:@tcp(127.0.0.1:3306)/pwm?charset=utf8mb4|$MYSQL_URI_ESCAPED|g" \
      | sed 's|AccessKeyID: CHANGE_ME|AccessKeyID: '"$MINIO_KEY_ESCAPED"'|g' \
      | sed 's|SecretAccessKey: CHANGE_ME|SecretAccessKey: '"$MINIO_SECRET_ESCAPED"'|g' \
      | sed 's#UseSSL: false#UseSSL: '"$MINIO_SSL"'#g' \
      | sed "s|localhost:9000|$MINIO_URI_ESCAPED|g" \
      | sed "s|127.0.0.1:9092|$KAFKA_HOST_ESCAPED|g" \
      | sed "s|http://pwm_web_server:8080|$PWM_WEB_URL_ESCAPED|g" \
      | sed "s|Name: \"me\"|Name: \"$PWM_VERIFY_PROVIDER_ESCAPED\"|g" \
      | sed "s|Environment: \"Development\"|Environment: \"$PWM_ENVIRONMENT_ESCAPED\"|g" \
      | sed "s|RequestTimeout: [^ ]*|RequestTimeout: $PWM_VERIFY_TIMEOUT_ESCAPED|g" \
      | sed "s|AutoVerifyEnabled: false|AutoVerifyEnabled: $PWM_AUTO_VERIFY_ENABLED|g" \
      | sed "s|BypassEnabled: false|BypassEnabled: $PWM_OTP_BYPASS_ENABLED|g" \
      | sed "s|BypassAllowInProduction: false|BypassAllowInProduction: $PWM_OTP_BYPASS_ALLOW_PRODUCTION|g" \
      | sed "s|BypassCode: \"\"|BypassCode: \"$PWM_OTP_BYPASS_CODE_ESCAPED\"|g" \
      | sed "s|ListenOn: $PWM_HOST:20010|ListenOn: $PWM_HOST:$PWM_BFF_PORT|g" \
      | sed "s|ListenOn: $PWM_HOST:8801|ListenOn: $PWM_HOST:$PWM_HTTP_PORT|g" \
      | cat > $CONFIG_TARGET_DIR/$file
  done
}

createConfigs

exec /bin/bash /app/bin/runall.sh
