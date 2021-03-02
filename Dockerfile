FROM debian:buster

RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install vim nginx wget openssl php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip mariadb-server mariadb-client

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-english.tar.gz && \
    tar -xzf phpMyAdmin-4.9.7-english.tar.gz && \
    rm -rf phpMyAdmin-4.9.7-english.tar.gz && \
    mv phpMyAdmin-4.9.7-english /var/www/html/phpmyadmin

RUN wget http://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm -rf latest.tar.gz && \
    mv wordpress /var/www/html/

COPY ./wp-config.php /var/www/html/wordpress/
COPY ./config.inc.php /var/www/html/phpmyadmin/

RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/*

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=ru/ST=Kazan/L=Kazan/O=no/OU=no/CN=mhuf" -keyout /etc/ssl/private/mhuf.key -out /etc/ssl/certs/mhuf.crt

COPY ./default /etc/nginx/sites-available/
RUN rm -rf /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/	
COPY start.sh .
COPY autoindex.sh .

RUN chmod 755 start.sh

EXPOSE 80 443
	
ENTRYPOINT ./start.sh

#CMD start.sh
