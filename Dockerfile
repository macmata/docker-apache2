#how to build 
#sudo docker build -t apache2 .
#how to run 
#sudo docker run -p 8080:8080 --name apache_process -d  apache2 /usr/sbin/apache2ctl -D FOREGROUND

FROM ubuntu:14.04

MAINTAINER Alexadnre Leblanc

RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y build-essential
RUN apt-get install -y libapache2-mod-proxy-html libxml2-dev 

RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_ajp
RUN a2enmod deflate
RUN a2enmod headers
RUN a2enmod proxy_balancer
RUN a2enmod proxy_connect
RUN a2enmod proxy_html
RUN a2enmod xml2enc 

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost

#copy the web dir to docker, folder MUST be in same dir as the execution , in the case the dockerfile 
COPY ./mainline /var/www/mainline 

#ADD all the file to setup configuration 
ADD ./000-default.conf /etc/apache2/sites-available/

#clean enabled site before we add our own and make symlink and restart apache to see if there is any error
RUN rm /etc/apache2/sites-enabled//000-default.conf && ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/ && chown -R www-data:www-data /var/www/ && service apache2 restart
