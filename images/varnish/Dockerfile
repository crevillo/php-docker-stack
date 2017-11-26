FROM        ubuntu:16.04
MAINTAINER  The Cocktail <ruby@the-cocktail.com>

ENV DEBIAN_FRONTEND noninteractive

# Update apt sources
#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list


# Update the package repository
RUN apt-get -qq update

RUN apt-get install curl gnupg -y
RUN curl -L https://packagecloud.io/varnishcache/varnish41/gpgkey | apt-key add -
RUN apt-get install -y apt-transport-https -y
RUN echo "deb https://packagecloud.io/varnishcache/varnish41/ubuntu/ trusty main" >> /etc/apt/sources.list.d/varnishcache_varnish41.list
RUN echo "deb-src https://packagecloud.io/varnishcache/varnish41/ubuntu/ trusty main" >> /etc/apt/sources.list.d/varnishcache_varnish41.list

RUN apt-get -qq update
# Install base system
RUN apt-get install -y varnish vim git automake libtool m4 python-docutils
RUN apt-get install varnish-dev -y

RUN cd / && git clone https://github.com/varnish/varnish-modules
RUN cd /varnish-modules && ./bootstrap && ./configure
RUN cd /varnish-modules && make && make install


# Make our custom VCLs available on the container
ADD default.vcl /etc/varnish/default.vcl

# Export environment variables
ENV VARNISH_PORT 6081

EXPOSE 6081

ADD start /start

RUN chmod 0755 /start

CMD ["/start"]
