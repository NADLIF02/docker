#PHP-apache
FROM ubuntu:latest

LABEL MAINTAINER Docker version 1.0

ENV DEBIAN_FRONTEND noninteractive

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-cli \
    php-fpm \
    php-json \
    php-common \
    php-mysql \
    php-zip \
    php-gd \
    php-mbstring \
    php-curl \
    php-xml \
    php-pear \
    php-bcmath \
    unzip \
    wget && \
    a2enmod php7.4 && \
    a2enmod rewrite


RUN wget http://www.sentrifugo.com/home/downloadfile?file_name=Sentrifugo.zip -O Sentrifugo.zip
RUN unzip Sentrifugo.zip
RUN mv Sentrifugo_3.2 /var/www/html/sentrifugo
RUN chown -R www-data:www-data /var/www/html/sentrifugo/
RUN chmod -R 755 /var/www/html/sentrifugo/

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
