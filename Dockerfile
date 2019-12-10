FROM ubuntu:16.04

RUN apt-get update
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y php php-pear php-fpm php-dev php-zip php-curl php-xmlrpc php-gd php-mysql php-mbstring php-xml libapache2-mod-php iptables screen sysbench
RUN apt-get install -y apache2
RUN systemctl enable apache2
CMD service apache2 start
EXPOSE 21 22 80 443 8080
