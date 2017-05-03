
FROM resin/rpi-raspbian:latest
MAINTAINER Julien Ancelin / rpi-docker-lizmap
# Install 
RUN apt-get -y update \
    && apt-get -t jessie install -y  python-simplejson xauth htop vim curl ntp ntpdate ssl-cert\ 
    python-software-properties git wget unzip \
    apache2 apache2-mpm-worker apache2-mpm-prefork apache2-bin apache2-data \
    libapache2-mod-fcgid libapache2-mod-php5 php5 php5-common php5-cgi php5-curl\
    php5-cli php5-sqlite php5-gd php5-pgsql \
    && apt-get clean && apt-get -y autoremove
#config 
RUN a2dismod php5; a2enmod actions; a2enmod fcgid ; a2enmod ssl; a2enmod rewrite; a2enmod headers; \
    a2enmod deflate; a2enmod php5

RUN ls -l /home/
COPY files/ /home/files/

# pg service file
ENV PGSERVICEFILE /etc/pg_service.conf
#-----------------install lizmap-web-client-------------------------------
# Download & unzip & install
ADD https://github.com/3liz/lizmap-web-client/archive/3.1.1.zip /var/www/

RUN chmod +x /home/files/setup.sh \
    && /home/files/setup.sh
VOLUME  /var/www/websig/lizmap/var
VOLUME /home

RUN chmod 0755 /home/files/start.sh
# Open port 80 443 
EXPOSE 80 443
# Now launch apache in the foreground
CMD /home/files/start.sh

