FROM debian:buster
LABEL maintainer="mhufflep@student.21-school.ru"

RUN apt-get -y update && apt-get -y upgrade

#-- utilities
RUN apt-get -y install vim nginx wget openssl \
	php-fpm php-mysql php-curl php-gd php-intl \
	php-mbstring php-soap php-xml php-xmlrpc php-zip \
	mariadb-server mariadb-client

#-- phpmyadmin --
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-english.tar.gz && \
    tar -xzf phpMyAdmin-4.9.7-english.tar.gz && \
    rm -rf phpMyAdmin-4.9.7-english.tar.gz && \
    mv phpMyAdmin-4.9.7-english /var/www/html/phpmyadmin

COPY srcs/config.inc.php /var/www/html/phpmyadmin/

#-- wordpress --
RUN wget http://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm -rf latest.tar.gz && \
    mv wordpress /var/www/html/

COPY srcs/wp-config.php /var/www/html/wordpress/

RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/*

#-- SSL --
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
				-subj "/C=ru/ST=Kazan/L=Kazan/O=no/OU=no/CN=mhuf" \
				-keyout /etc/ssl/private/mhufflep.key -out /etc/ssl/certs/mhufflep.crt


COPY srcs/create.sql ./

#-- nginx conf --
COPY srcs/default /etc/nginx/sites-available/default
RUN rm -rf /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/	

#-- scripts --
COPY srcs/start.sh ./
COPY srcs/autoindex.sh ./
RUN chmod 755 start.sh
RUN chmod 755 autoindex.sh

EXPOSE 80 443
	
ENTRYPOINT ./start.sh