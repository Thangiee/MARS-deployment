#!/usr/bin/env bash

backup_dir="backup/$(date +%F_%R)"

mkdir -p ${backup_dir}
docker exec marsdeployment_db_1 pg_dump -O -U postgres postgres > "./$backup_dir/db.sql"
docker cp marsdeployment_backend_1:/app/faces "./$backup_dir/faces"

echo "> backup written to $(pwd)/$backup_dir"