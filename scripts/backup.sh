#!/bin/sh
set -eu
STAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p backups
docker compose exec -T postgres pg_dump -U postgres -d hr_system -Fc > "backups/hr_${STAMP}.dump"
find backups -type f -name "hr_*.dump" -mtime +14 -delete
echo "Backup created: backups/hr_${STAMP}.dump"
