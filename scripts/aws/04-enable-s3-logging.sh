#!/bin/bash
# 04-enable-s3-logging.sh
# Habilita Server Access Logging para un bucket S3

set -e

SOURCE_BUCKET="moodstream-proyecto"
TARGET_BUCKET="moodstream-proyecto-logs"
TARGET_PREFIX="s3-access-logs/"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "1) Verificando bucket destino..."
aws s3api head-bucket --bucket "$TARGET_BUCKET" 2>/dev/null || {
  echo "El bucket $TARGET_BUCKET no existe. Creándolo en us-east-1..."
  aws s3api create-bucket --bucket "$TARGET_BUCKET" --region us-east-1
}

echo "2) Aplicando política al bucket destino..."
cat > /tmp/s3-log-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3ServerAccessLogsPolicy",
      "Effect": "Allow",
      "Principal": {
        "Service": "logging.s3.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::$TARGET_BUCKET/$TARGET_PREFIX*",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:s3:::$SOURCE_BUCKET"
        },
        "StringEquals": {
          "aws:SourceAccount": "$ACCOUNT_ID"
        }
      }
    }
  ]
}
EOF

aws s3api put-bucket-policy \
  --bucket "$TARGET_BUCKET" \
  --policy file:///tmp/s3-log-policy.json

echo "3) Habilitando server access logging en $SOURCE_BUCKET ..."
aws s3api put-bucket-logging \
  --bucket "$SOURCE_BUCKET" \
  --bucket-logging-status "{
    \"LoggingEnabled\": {
      \"TargetBucket\": \"$TARGET_BUCKET\",
      \"TargetPrefix\": \"$TARGET_PREFIX\"
    }
  }"

echo "4) Verificando configuración aplicada..."
aws s3api get-bucket-logging --bucket "$SOURCE_BUCKET"

echo "Listo. Ahora corre tu pipeline o genera actividad sobre el bucket origen."