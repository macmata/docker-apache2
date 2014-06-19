FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y apache2

RUN a2enmod rewrite

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
ENV APACHE_DOCUMENTROOT /var/www


ADD ./001-docker.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/

#ADD all the file to setup configuration 


EXPOSE 80


# the script can serve a list of command
ADD ./run.sh /opt/run.sh
RUN chmod 755 /opt/*.sh
CMD ["/bin/bash", "/opt/startup.sh"]
