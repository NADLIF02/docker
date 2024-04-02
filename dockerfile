#PHP-apache
FROM ubuntu:latest

LABEL MAINTAINER Docker version 1.0

ENV DEBIAN_FRONTEND noninteractive

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN apt-get update
RUN apt-get install -y apache2 unzip php7.4 php7.4-common php7.4-mbstring php7.4-xmlrpc php7.4-soap php7.4-gd php7.4-xml php7.4-intl php7.4-mysql php7.4-cli php7.4-ldap php7.4-zip php7.4-curl wget
rm -rf /var/lib/apt/lists/*

RUN wget http://www.sentrifugo.com/home/downloadfile?file_name=Sentrifugo.zip -O Sentrifugo.zip
RUN unzip Sentrifugo.zip
RUN mv Sentrifugo_3.2 /var/www/html/sentrifugo
RUN chown -R www-data:www-data /var/www/html/sentrifugo/
RUN chmod -R 755 /var/www/html/sentrifugo/

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
