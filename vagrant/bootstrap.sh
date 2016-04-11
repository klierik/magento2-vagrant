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
echo ""
echo "MySQL 5.6 need to be installed manually."
echo "Please run next command and enter password or whatever system will ask you..."
echo ""
echo "$ sudo apt-get -y install mysql-server-5.6 mysql-client-5.6 && mysql_secure_installation"
echo "$ sudo apt-get -y autoremove && sudo apt-get -y autoclean"
echo ""
echo "After MySQL Installation complete run:"
echo "$ mysql -u root -p"
echo "> create database magento;"
echo "> GRANT ALL ON magento.* TO magento@localhost IDENTIFIED BY 'magento';"
echo "=================================================="



echo "=================================================="
echo "INSTALLING MAGENTO 2"
echo "=================================================="
MAGENTO_ADMIN_USER=admin
MAGENTO_ADMIN_PASSWORD=`pwgen -n 10 1`
MAGENTO_ADMIN_EMAIL=admin@magento2-vagrant.com
echo "########################################################"
echo "# Your Magento admin user is: $MAGENTO_ADMIN_USER"
echo "# Your Magento admin password is: $MAGENTO_ADMIN_PASSWORD"
echo "# Your Magento admin email is: $MAGENTO_ADMIN_EMAIL"
echo "########################################################"

cd /vagrant/httpdocs/bin
php magento setup:install --db-user=$MYSQL_MAGENTO_USER \
    --db-name=$MYSQL_MAGENTO_DB --db-password=$MYSQL_MAGENTO_PASSWORD \
    --admin-user=$MAGENTO_ADMIN_USER --admin-password=$MAGENTO_ADMIN_PASSWORD \
    --admin-email=$MAGENTO_ADMIN_EMAIL --admin-firstname=Admin --admin-lastname=Admin \
    --base-url=http://magento2-vagrant.dev/

crontasks=`tempfile`
cat > $crontasks <<_EOF
*/1 * * * * /usr/bin/php -c /etc/php5/cli/php.ini /vagrant/httpdocs/bin/magento cron:run
*/1 * * * * /usr/bin/php -c /etc/php5/cli/php.ini /vagrant/httpdocs/update/cron.php
*/1 * * * * /usr/bin/php -c /etc/php5/cli/php.ini /vagrant/httpdocs/bin/magento setup:cron:run
_EOF
crontab $crontasks && rm -f $crontasks

echo "=================================================="
echo "CLEANING..."
echo "=================================================="
apt-get -y autoremove
apt-get -y autoclean


echo "=================================================="
echo "============= INSTALLATION COMPLETE =============="
echo "=================================================="
