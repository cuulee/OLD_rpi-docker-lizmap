#!/bin/bash

set -e

mkdir /etc/apache2/ssl 
RUN /usr/sbin/make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/ssl/apache.pem 
RUN /usr/sbin/a2ensite default-ssl 

    mv /home/files/mod_deflate.conf /etc/apache2/conf.d/mod_deflate.conf  
    mv /home/files/php.conf /etc/apache2/conf.d/php.conf 
    mv /home/files/fcgid.conf /etc/apache2/mods-enabled/fcgid.conf 
    mv /home/files/apache_https.conf /etc/apache2/sites-available/default-ssl.conf 
    mv /home/files/apache.conf /etc/apache2/sites-available/000-default.conf 
    mv /home/files/apache2.conf /etc/apache2/apache2.conf 
    mv /home/files/fcgid.conf /etc/apache2/mods-available/fcgid.conf 
    mv /home/files/pg_service.conf /etc/pg_service.conf 
    mv /home/files/setup.sh /setup.sh 
    mv /home/files/index.html /var/www/index.html 
    mv /home/files/start.sh /start.sh
    chmod 0755 /home/files/start.sh

# unzip lizmap master
unzip /var/www/3.1.1.zip -d /var/www/
mv /var/www/lizmap-web-client-3.1.1/ /var/www/websig/
rm /var/www/3.1.1.zip
# Set rights & active config
chmod +x /var/www/websig/lizmap/install/set_rights.sh
/var/www/websig/lizmap/install/set_rights.sh www-data www-data
cp /var/www/websig/lizmap/var/config/lizmapConfig.ini.php.dist /var/www/websig/lizmap/var/config/lizmapConfig.ini.php
cp /var/www/websig/lizmap/var/config/localconfig.ini.php.dist /var/www/websig/lizmap/var/config/localconfig.ini.php
cp /var/www/websig/lizmap/var/config/profiles.ini.php.dist /var/www/websig/lizmap/var/config/profiles.ini.php
#  Installer
php /var/www/websig/lizmap/install/installer.php
# Set rights
chown :www-data  /var/www/websig/lizmap/www -R
chmod 775  /var/www/websig/lizmap/www -R
chown :www-data /var/www/websig/lizmap/var -R
chmod 775  /var/www/websig/lizmap/var -R
cp -avr /var/www/websig/lizmap/var var/www/websig/lizmap/var_install
