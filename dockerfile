#PHP-apache
FROM ubuntu

MAINTAINER Docker version 1.0

ENV DEBIAN_FRONTEND noninteractive

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN apt-get update && apt-get install -y apache2
RUN apt-get install unzip php7.2 php7.2-common php7.2-mbstring php7.2-xmlrpc php7.2-soap php7.2-gd php7.2-xml php7.2-intl php7.2-mysql php7.2-cli php7.2 php7.2-ldap php7.2-zip php7.2-curl wget -y
RUN wget http://www.sentrifugo.com/home/downloadfile?file_name=Sentrifugo.zip -O Sentrifugo.zip
RUN unzip Sentrifugo.zip
RUN mv Sentrifugo_3.2 /var/www/html/sentrifugo
RUN chown -R www-data:www-data /var/www/html/sentrifugo/
RUN chmod -R 755 /var/www/html/sentrifugo/

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
