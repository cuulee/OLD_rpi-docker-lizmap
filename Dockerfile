
FROM resin/rpi-raspbian
MAINTAINER Julien Ancelin / rpi_docker-qgis-server-lizmap
#RUN  export DEBIAN_FRONTEND=noninteractive
#ENV  DEBIAN_FRONTEND noninteractive
#RUN  dpkg-divert --local --rename --add /sbin/initctl
# Add sid
RUN echo "deb    http://http.debian.net/debian sid main " >> /etc/apt/sources.list
RUN echo "deb    http://http.debian.net/debian jessie-backports main " >> /etc/apt/sources.list
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 8B48AD6246925553
RUN gpg -a --export 8B48AD6246925553 | sudo apt-key add -
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 7638D0442B90D010
RUN gpg -a --export 7638D0442B90D010 | sudo apt-key add -
RUN apt-get -y update
# Install 

RUN RUN apt-get -t jessie-backports install -y --force-yes python-simplejson xauth htop nano curl ntp ntpdate \ 
    python-software-properties git wget unzip apache2 apache2-mpm-worker libapache2-mod-fcgid php5 php5-cgi\
    php5-curl php5-cli php5-sqlite php5-gd php5-pgsql libapache2-mod-php5 apache2-mpm-prefork
    
RUN apt-get -t sid install -y --force-yes qgis-server
    
RUN a2dismod php5; a2enmod actions; a2enmod fcgid ; a2enmod ssl; a2enmod rewrite; a2enmod headers; \
    a2enmod deflate; a2enmod php5
#config compression
ADD mod_deflate.conf /etc/apache2/conf.d/mod_deflate.conf
#config php5
ADD php.conf /etc/apache2/conf.d/php.conf
# Remove the default mod_fcgid configuration file
RUN rm -v /etc/apache2/mods-enabled/fcgid.conf
# Copy a configuration file from the current directory
ADD fcgid.conf /etc/apache2/mods-enabled/fcgid.conf
# Open port 80 & mount /home 
EXPOSE 80
# Mount /home (persistent data)
VOLUME /home
# Configure apache
ADD apache2.conf /etc/apache2/apache2.conf
ADD apache.conf /etc/apache2/sites-available/000-default.conf
ADD apache.conf /etc/apache2/sites-enabled/000-default.conf
ADD fcgid.conf /etc/apache2/mods-available/fcgid.conf
ADD pg_service.conf /etc/pg_service.conf
# pg service file
ENV PGSERVICEFILE /etc/pg_service.conf
#-----------------install lizmap-web-client-------------------------------
# Download & unzip
ADD https://github.com/3liz/lizmap-web-client/archive/master.zip /var/www/
# download setup.sh and play it for install lizmap3
ADD setup.sh /setup.sh
RUN chmod +x /setup.sh
RUN /setup.sh
# link volume lizmap_config persistent data host  if "-v /home/lizmap_var:/var/www/websig/lizmap/var" on docker run
VOLUME  /var/www/websig/lizmap/var
#add a redirection for just call the ip
ADD index.html /var/www/index.html
# Now launch apache in the foreground
CMD apachectl -D FOREGROUND
