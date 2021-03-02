service mysql start
service php7.3-fpm start

service --status-all

echo "CREATE DATABASE wordpress" | mysql -u root --skip-password
echo "GRANT ALL ON wordpress.* TO 'root'@'localhost' IDENTIFIED BY ''" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES" | mysql -u root --skip-password

nginx -g 'daemon off;'