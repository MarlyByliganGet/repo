#!/bin/bash
#set -x

#Variable
d=$(date +"%Y-%m-%d")
backup_folder="/Path/to/your/dir"
backup_process_folder="/Path/to/your/dir/backup_log"
backup_process_log="$backup_process_folder/$d-date.log"
full_backup_name="$backup_folder/full_backup$d.sql"
backup_folder_for_second="/Path/to/your/dir/for_second"
#status_mysql={/usr/bin/pgrep -f mysql | /usr/bin/wc -l }

#Function for logging backup
function writeLog(){
    echo -e "(date +"%Y-%m-%d %T" \t $1)" >> $backup_process_log
}

#Start logging process script
writeLog "==========Star of Backup $d =========="

#Check is mysql works
#in process creating this function


#Service commands for start mysqldump
mkdir -p $backup_folder $backup_process_folder 2> /dev/null
touch $backup_process_log
mysqldump --databases callme --single-transaction > $backup_folder$d-backup.sql

#mysqldump backup archiving
tar -Pzcvf $backup_folder$(date +"%Y-%m-%d")-backup.sql.tar.gz $backup_folder$d-backup.sql
cd $backup_to_DataProtector && rm -f ./*
cp $backup_folder$(date +"%Y-%m-%d")-backup.sql.tar.gz $backup_to_DataProtector

#delete oldest backup *.sql files
find ${backup_folder}  -type f -name '*.sql' -mtime 0.05 -exec rm -f {} \;

#delete oldest backup *.sql.tar.gz files
find ${backup_folder}  -type f -name '*.sql.tar.gz' -mtime 3 -exec rm -f {} \;
