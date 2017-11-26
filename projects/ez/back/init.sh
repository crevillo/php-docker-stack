#!/usr/bin/env bash

cd /var/www/html


# generate the parameters_dev file to connect with the db
if [ ! -f "app/config/parameters_${SYMFONY_ENV}.yml" ]; then
cat <<EOT >> app/config/parameters_${SYMFONY_ENV}.yml
parameters:
    secret: ThisEzPlatformTokenIsNotSoSecretChangeIt
    database_driver: pdo_mysql
    database_host: mysql
    database_port: null
    database_name: ${DATABASE_NAME}_${SYMFONY_ENV}
    database_user: root
    database_password: rootdev
EOT
fi

composer install

DB=${DATABASE_NAME}_${SYMFONY_ENV}
RESULT=`mysqlshow --user=root --password=rootdev --host=mysql $DB| grep -v Wildcard | grep -o $DB`
if [ "$RESULT" == "$DB" ]; then
    echo YES
else
    mysql -u root -prootdev --host=mysql -e "CREATE DATABASE $DB"
    php app/console ezplatform:install clean
fi


php-fpm
