#!/usr/bin/env bash
set -euo pipefail

# Dump database and upload to S3
DB_TYPE="${DB_TYPE:-postgres}"
S3_BUCKET="${S3_BUCKET:?Set S3_BUCKET}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="backup_${TIMESTAMP}.sql.gz"
TMP="/tmp/$FILENAME"

if [ "$DB_TYPE" = "postgres" ]; then
  PGPASSWORD="$DB_PASSWORD" pg_dump -h "$DB_HOST" -U "$DB_USER" "$DB_NAME" | gzip > "$TMP"
elif [ "$DB_TYPE" = "mysql" ]; then
  mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" | gzip > "$TMP"
fi

aws s3 cp "$TMP" "s3://$S3_BUCKET/backups/$FILENAME" \
  --storage-class STANDARD_IA

rm "$TMP"
echo "Backup uploaded: s3://$S3_BUCKET/backups/$FILENAME"
