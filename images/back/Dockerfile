FROM php:7.1-fpm
MAINTAINER The Cocktail <ruby@the-cocktail.com>

RUN apt-get update -qq && apt-get install libicu-dev -y
RUN apt-get install libssl-dev -y
RUN apt-get install libpng12-dev -y

RUN docker-php-ext-install intl

RUN docker-php-ext-install ftp
RUN docker-php-ext-install gd

RUN apt-get install libldb-dev libldap2-dev -y
RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so
RUN docker-php-ext-install ldap

RUN apt-get install libmcrypt-dev -y
RUN docker-php-ext-install mcrypt

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install opcache

RUN apt-get install libxml2-dev -y
RUN docker-php-ext-install soap

RUN apt-get install libxslt-dev -y
RUN docker-php-ext-install xsl
RUN docker-php-ext-install zip

RUN apt-get install libmagickwand-dev -y
RUN pecl install imagick
RUN echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini

RUN apt install libmemcached-dev -y
RUN pecl install memcached
RUN echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini

RUN pecl install redis
RUN echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

RUN pecl install xdebug
RUN echo "zend_extension=xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini

ARG user

RUN sed -rie "s|user = www-data|user = $user|g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -rie "s|listen.owner = www-data|listen.owner = $user|g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -rie "s|;php_flag\[display_errors\] = off|php_flag\[display_errors\] = on|g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -rie "s|;php_admin_value\[error_log\] = /var/log/fpm-php.www.log|php_admin_value\[error_log] = /var/log/fpm-php.www.log|g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -rie "s|;php_admin_flag\[log_errors\] = on|php_admin_flag\[log_errors\] = on|g" /usr/local/etc/php-fpm.d/www.conf && \
    echo "php_admin_value[session.save_handler]=memcached" >> /usr/local/etc/php-fpm.d/www.conf && \
    echo "php_admin_value[session.save_path]=memcache:11211" >> /usr/local/etc/php-fpm.d/www.conf

RUN apt-get install wget git mysql-client telnet -y

ADD ./install-composer.sh /var/install/
ADD ./tmp/init.sh /var/install/

RUN ["chmod", "+x", "/var/install/install-composer.sh"]
RUN ["chmod", "+x", "/var/install/init.sh"]

RUN /var/install/install-composer.sh
RUN useradd -ms /bin/bash $user

USER $user

WORKDIR /var/www/html

CMD /var/install/init.sh


