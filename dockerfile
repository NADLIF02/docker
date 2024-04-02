# Utiliser la dernière version d'Ubuntu comme image de base
FROM ubuntu:latest

LABEL MAINTAINER="Docker version 1.0"

ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour les paquets et installer les prérequis
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
    a2enmod rewrite

# Télécharger et installer Sentrifugo
RUN wget http://www.sentrifugo.com/home/downloadfile?file_name=Sentrifugo.zip -O Sentrifugo.zip && \
    unzip Sentrifugo.zip -d /var/www/html/ && \
    mv /var/www/html/Sentrifugo_3.2/* /var/www/html/ && \
    rm -Rf Sentrifugo.zip /var/www/html/Sentrifugo_3.2 && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

# Configurer Apache pour servir Sentrifugo à la racine
RUN sed -i 's|/var/www/html|/var/www/html/sentrifugo|g' /etc/apache2/sites-available/000-default.conf && \
    sed -i 's|/var/www/|/var/www/html/sentrifugo|g' /etc/apache2/apache2.conf

# Activer le module mod_rewrite d'Apache pour Sentrifugo
RUN a2enmod rewrite

# Corriger les problèmes de .htaccess en permettant la réécriture dans /var/www
RUN echo '<Directory "/var/www/html/sentrifugo">\n\
    AllowOverride All\n\
</Directory>' >> /etc/apache2/sites-available/000-default.conf

# Exposer le port 80
EXPOSE 80

# Démarrer Apache en premier plan
CMD ["apache2ctl", "-D", "FOREGROUND"]
