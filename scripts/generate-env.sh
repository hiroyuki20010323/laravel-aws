#!/bin/bash
set -e

REGION="ap-northeast-1"
APP_DIR="/var/www/laravel"

DB_HOST=$(aws ssm get-parameter --name "/laravel/production/db_host" --region $REGION --query "Parameter.Value" --output text)
DB_DATABASE=$(aws ssm get-parameter --name "/laravel/production/db_database" --region $REGION --query "Parameter.Value" --output text)
DB_USERNAME=$(aws ssm get-parameter --name "/laravel/production/db_username" --region $REGION --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --name "/laravel/production/db_password" --with-decryption --region $REGION --query "Parameter.Value" --output text)
APP_KEY=$(aws ssm get-parameter --name "/laravel/production/app_key" --with-decryption --region $REGION --query "Parameter.Value" --output text)
APP_URL=$(aws ssm get-parameter --name "/laravel/production/app_url" --region $REGION --query "Parameter.Value" --output text)

cat > "$APP_DIR/.env" <<EOF
APP_NAME=Laravel
APP_ENV=production
APP_KEY=${APP_KEY}
APP_DEBUG=false
APP_URL=${APP_URL}

LOG_CHANNEL=stack
LOG_LEVEL=info

DB_CONNECTION=mysql
DB_HOST=${DB_HOST}
DB_PORT=3306
DB_DATABASE=${DB_DATABASE}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}

CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
EOF

echo ".env generated successfully"
