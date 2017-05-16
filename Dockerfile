FROM ubuntu:16.04

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install python-software-properties software-properties-common language-pack-en-base
RUN LC_ALL=C.UTF-8 add-apt-repository -y -s ppa:ondrej/php
RUN apt-get -y update
RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN apt-get install -y apache2 libapache2-mod-php7.1 php7.1 \
&& php-xdebug php7.1-mbstring sqlite3 php7.1-mysql \
&& php-apcu php-apcu-bc php-imagick php-memcached php-pear curl imagemagick php7.1-dev \
&& php7.1-phpdbg php7.1-gd php7.1-json php7.1-curl php7.1-sqlite3 php7.1-intl apache2 vim \
&& git-core wget libsasl2-dev libssl-dev libsslcommon2-dev libcurl4-openssl-dev autoconf g++ \
&& php7.1-bcmath

RUN make openssl libssl-dev libcurl4-openssl-dev pkg-config libsasl2-dev libpcre3-dev

RUN a2enmod headers
RUN a2enmod rewrite

RUN echo "zend_extension=/usr/lib/php/20160303/xdebug.so" >> /etc/php/7.1/apache2/php.ini
RUN echo "xdebug.max_nesting_level=250" >> /etc/php/7.1/apache2/php.ini
RUN echo "xdebug.var_display_max_depth=10" >> /etc/php/7.1/apache2/php.ini
RUN echo "xdebug.remote_enable=true" >> /etc/php/7.1/apache2/php.ini
RUN echo "xdebug.remote_handler=dbgp" >> /etc/php/7.1/apache2/php.ini
RUN echo "xdebug.remote_mode=req" >> /etc/php/7.1/apache2/php.ini
RUN echo "xdebug.remote_port=9000" >> /etc/php/7.1/apache2/php.ini
RUN echo "xdebug.remote_host=192.168.100.5" >> /etc/php/7.1/apache2/php.ini #provide local machine IP
RUN echo "xdebug.idekey=phpstorm-xdebug" >> /etc/php/7.1/apache2/php.ini
RUN echo "xdebug.remote_autostart=1" >> /etc/php/7.1/apache2/php.ini
RUN echo "xdebug.remote_log=/var/log/apache2/xdebug_remote.log" >> /etc/php/7.1/apache2/php.ini


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR


VOLUME [ "/var/www/html" ]
WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/apache2" ]
CMD ["-D", "FOREGROUND"]
