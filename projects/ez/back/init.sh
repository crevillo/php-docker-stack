#!/usr/bin/env bash

cd /var/www/html

# generate the parameters_dev file to connect with the db
if [! -f "app/config/parameters_dev.yml"]; then
cat <<EOT >> app/config/parameters_dev.yml
parameters:
    secret: ThisEzPlatformTokenIsNotSoSecretChangeIt
    database_driver: pdo_mysql
    database_host: mysql
    database_port: null
    database_name: ezplatform
    database_user: root
    database_password: rootdev
EOT
fi

composer install

RESULT=`mysqlshow --user=root --password=rootdev --host=mysql ezplatform| grep -v Wildcard | grep -o ezplatform`
if [ "$RESULT" == "ezplatform" ]; then
    echo YES
else
    mysql -u root -prootdev --host=mysql -e "CREATE DATABASE ezplatform"
    php app/console ezplatform:install clean
fi


php-fpm
