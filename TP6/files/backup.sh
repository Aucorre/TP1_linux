#!/bin/bash
# Archives nextcloud data.
# audren



name=("/srv/backup/nextcloud_$(date +"%y%m%d_%H%m%S").tar.gz")
cd /var/www/
/usr/bin/tar -czvf "$name" nextcloud/ &> /dev/null

# Success
echo "Backup "$name" created successfully."

# Write a log
log_prefix=$(date +"[%y/%m/%d %H:%m:%S]")
log_line="${log_prefix} Backup "$name" created successfully."
echo "${log_line}" >> /var/log/backup/backup.log
