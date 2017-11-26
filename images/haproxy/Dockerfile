FROM haproxy
MAINTAINER The Cocktail <ruby@the-cocktail.com>

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

ADD haproxy.crt /haproxy.crt
ADD haproxy.key /haproxy.key

RUN cat /haproxy.crt /haproxy.key > /haproxy.pem