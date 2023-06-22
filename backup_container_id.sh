#!/bin/bash

# Get the container IDs from user input
app_container_id="your container id"
db_container_id="yuor db container id"

# Define the backup directory
backup_dir="/home/backup" # change this to your backup directory

# Create a timestamp for the backup
timestamp=$(date +"%Y%m%d%H%M%S")

# Create a backup filename with container ID and timestamp

backup_name="backup_${app_container_id}_${timestamp}"
backup_filename="b_${backup_name}.tar"

# Create the backup of the main container

docker commit -p $app_container_id $backup_name


# save the image to a tar file
docker save -o "$backup_dir/$backup_filename" $backup_name

# Check if the main container backup was successful
if [ $? -eq 0 ]; then
  echo "Main container backup created successfully: $backup_name"
else
  echo "Main container backup creation failed."
fi

# Create a backup of the database container
db_backup_dir="$backup_dir/database"
db_backup_filename="database_${db_container_id}_${timestamp}.sql"


docker exec $db_container_id sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > "$db_backup_dir/$db_backup_filename"

# Check if the database container backup was successful
if [ $? -eq 0 ]; then
  echo "Database container backup created successfully: $db_backup_filename"
else
  echo "Database container backup creation failed."
fi