#!/usr/bin/env bash


echo "=================================================="
echo "Aloha! Now we will try to Install Ubuntu 14.04 LTS"
echo "with Apache 2.4, PHP 5.6, MySQL 5.6(manual)"
echo "and others dependencies needed for Magento 2."
echo "Good luck :P"
echo "=================================================="


echo "=================================================="
echo "SET LOCALES"
echo "=================================================="

export DEBIAN_FRONTEND=noninteractive

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales


echo "=================================================="
echo "RUN UPDATE"
echo "=================================================="

apt-get update
apt-get upgrade


echo "=================================================="
echo "INSTALLING APACHE"
echo "=================================================="

apt-get -y install apache2

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant/httpdocs /var/www
fi

VHOST=$(cat <<EOF
<VirtualHost *:80>
  DocumentRoot "/var/www"
  ServerName magento2-vagrant.dev

  <Directory "/var/www">
    AllowOverride All
  </Directory>

  SetEnv MAGE_IS_DEVELOPER_MODE true
</VirtualHost>
EOF
)
echo "$VHOST" > /etc/apache2/sites-available/000-default.conf

echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/localhost.conf

a2enconf localhost
a2enmod rewrite
service apache2 restart


echo "=================================================="
echo "INSTALLING PHP"
echo "=================================================="

apt-get -y update
add-apt-repository ppa:ondrej/php5-5.6
apt-get -y update
apt-get -y install php5 php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl php5-xsl

service apache2 restart


echo "=================================================="
echo "INSTALLING GIT"
echo "=================================================="
apt-get -y install git


echo "=================================================="
echo "INSTALLING COMPOSER"
echo "=================================================="
curl --silent https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
php5enmod mcrypt

cd /vagrant/httpdocs
composer install

echo "=================================================="
echo "INSTALLING and CONFIGURE NTP"
echo "=================================================="
apt-get -y install ntp


echo "=================================================="
echo "INSTALLING MYSQL and CONFIGURE DATABASE"
echo "======== ATTENTION!!! READ THIS PLEASE ==========="
sudo apt-get install pwgen
MYSQL_ROOT_PASSWORD=`pwgen 10 1`
MYSQL_MAGENTO_DB=magento2
MYSQL_MAGENTO_USER=magento2
MYSQL_MAGENTO_PASSWORD=`pwgen 10 1`
echo "########################################################"
echo "# Your MySQL root password is: $MYSQL_ROOT_PASSWORD"
echo "# Your MySQL $MYSQL_MAGENTO_USER password is: $MYSQL_MAGENTO_PASSWORD"
echo "########################################################"
echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
sudo apt-get -y install mysql-server-5.6 mysql-client-5.6
echo "create database $MYSQL_MAGENTO_DB;" | mysql -u root -p$MYSQL_ROOT_PASSWORD
echo "GRANT ALL ON $MYSQL_MAGENTO_DB.* TO $MYSQL_MAGENTO_USER@localhost IDENTIFIED BY '$MYSQL_MAGENTO_PASSWORD';" | mysql -u root -p$MYSQL_ROOT_PASSWORD

echo "=================================================="
echo "CLEANING..."
echo "=================================================="
apt-get -y autoremove
apt-get -y autoclean


echo "=================================================="
echo "============= INSTALLATION COMPLETE =============="
echo "=================================================="
