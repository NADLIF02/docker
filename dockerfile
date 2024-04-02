# Utiliser la dernière version d'Ubuntu comme image de base
FROM ubuntu:latest

LABEL MAINTAINER="Docker version 1.0"

ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour les informations de paquet et installer Apache, PHP 8.3, et d'autres extensions nécessaires
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
    apache2 \
    php8.3 \
    libapache2-mod-php8.3 \
    php8.3-cli \
    php8.3-fpm \
    php8.3-json \
    php8.3-common \
    php8.3-mysql \
    php8.3-zip \
    php8.3-gd \
    php8.3-mbstring \
    php8.3-curl \
    php8.3-xml \
    php8.3-pear \
    php8.3-bcmath \
    unzip \
    wget && \
    a2enmod php8.3 && \
    a2enmod rewrite

# Télécharger et installer Sentrifugo
RUN wget http://www.sentrifugo.com/home/downloadfile?file_name=Sentrifugo.zip -O Sentrifugo.zip && \
    unzip Sentrifugo.zip && \
    mv Sentrifugo_3.2 /var/www/html/sentrifugo && \
    rm Sentrifugo.zip && \
    chown -R www-data:www-data /var/www/html/sentrifugo/ && \
    chmod -R 755 /var/www/html/sentrifugo/

# Modifier la configuration d'Apache pour servir Sentrifugo
RUN echo '<VirtualHost *:80>\n\
    ServerAdmin webmaster@localhost\n\
    DocumentRoot /var/www/html/sentrifugo\n\
    ErrorLog ${APACHE_LOG_DIR}/error.log\n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Exposer le port 80 pour le serveur web
EXPOSE 80

# Utiliser apache2ctl pour démarrer Apache en mode foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
