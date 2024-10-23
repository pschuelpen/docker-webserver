#!/bin/bash

# Start MySQL in the background
mysqld_safe --datadir=/var/lib/mysql &
echo "Starting MySQL..."

# Wait for MySQL to be ready
until mysqladmin ping --silent; do
    echo "Waiting for MySQL to start..."
    sleep 2
done

# Initialize MySQL database if it doesn't exist
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Initializing database..."
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

    # Create the user and grant privileges
    echo "Creating MySQL user '$DB_USER_NAME' and granting access..."
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$DB_USER_NAME'@'localhost' IDENTIFIED BY '$DB_USER_PASSWORD';"
    
    # Grant privileges for the user
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$DB_USER_NAME'@'localhost';"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
    
    # Check which DB initialization method to use
    if [ "$DB_INIT_METHOD" == "1" ]; then
        # Mode 1: Initialize with a single script
        if [ -f "$DB_INIT_SCRIPT_PATH" ]; then
            echo "Initializing database with a single script: $DB_INIT_SCRIPT_PATH"
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < "$DB_INIT_SCRIPT_PATH"
        else
            echo "Error: SQL script $DB_INIT_SCRIPT_PATH not found!"
            exit 1
        fi
    elif [ "$DB_INIT_METHOD" == "2" ]; then
        # Mode 2: Initialize with multiple scripts from a folder
        if [ -d "$DB_INIT_PATH" ]; then
            echo "Initializing database with scripts from folder: $DB_INIT_PATH"
            for script in "$DB_INIT_PATH"/*.sql; do
                if [ -f "$script" ]; then
                    echo "Running script: $script"
                    mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < "$script"
                fi
            done
        else
            echo "Error: Directory $DB_INIT_PATH not found!"
            exit 1
        fi
    else
        echo "Error: Invalid DB_INIT_METHOD value. Please set it to 1 (single script) or 2 (folder of scripts)."
        exit 1
    fi
fi

# Start Apache in the foreground
echo "Starting Apache..."
apache2-foreground
