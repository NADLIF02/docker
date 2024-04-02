# Utiliser la dernière version d'Ubuntu comme image de base
FROM ubuntu:latest

LABEL MAINTAINER="Docker version 1.0"

ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour les informations de paquet
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    # Ajouter le PPA pour PHP d'Ondřej Surý
    add-apt-repository ppa:ondrej/php && \
    apt-get update

# Ajouter le PPA pour PHP et installer Apache2 et PHP
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y apache2 php libapache2-mod-php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath && \
    a2enmod php && \
    a2enmod rewrite

    
# Activer le module PHP pour Apache
# Apache2 utilise `libapache2-mod-php` qui active automatiquement le module PHP approprié.
RUN a2enmod php8.0 && \
    a2enmod rewrite

# Télécharger et installer Sentrifugo
RUN wget http://www.sentrifugo.com/home/downloadfile?file_name=Sentrifugo.zip -O Sentrifugo.zip && \
    unzip Sentrifugo.zip && \
    mv Sentrifugo_3.2 /var/www/html/sentrifugo && \
    rm Sentrifugo.zip && \
    chown -R www-data:www-data /var/www/html/sentrifugo/ && \
    chmod -R 755 /var/www/html/sentrifugo/

# Configurer Apache pour servir Sentrifugo
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
