#!/bin/bash
#Archives the database of nextcloud into /srv/backup
#audren

name=("/srv/backup/nextcloud_db_$(date +"%y%m%d_%H%m%S").tar.gz")

# Fetch the database
/usr/bin/mysqldump -u root -pazerty nextcloud > /tmp/nextcloud.sql

# Archive it
/usr/bin/cd /tmp/
/usr/bin/tar -czvf $name nextcloud.sql &> /dev/null
/usr/bin/rm /tmp/nextcloud.sql

# Success
/usr/bin/echo "Backup "$name" created successfully."

# Write in logfile
log_prefix=$(date +"[%y/%m/%d %H:%m:%S]")
log_line="${log_prefix} Backup "$name" created successfully."
/usr/bin/echo "${log_line}" >> /var/log/backup/backup_db.log
