#!/usr/bin/env bash

yum -y install epel-release 
yum -y install vim 
yum -y install git 
yum -y install tmux 
yum -y install httpd 
yum -y install php 
yum -y install php-devel 
yum -y install php-gd 
yum -y install php-drush-drush 
yum -y install mysql-server 
yum -y install php-mysql 

echo "Configuring new system..."
echo "AddHandler php5-script .php" >> /etc/httpd/conf/httpd.conf
echo "AddType text/html .php" >> /etc/httpd/conf/httpd.conf
cd /var/www
rm -r html
cp -r /vagrant/dependencies/FSULibraries_backrest/drupal /var/www
mv drupal html
chmod -R 777 /var/www/html
rm /var/www/html/sites/default/settings.php
cp /vagrant/dependencies/default.settings.php /var/www/html/sites/default/settings.php
cp /vagrant/dependencies/ilsecolo.settings.php /var/www/html/sites/ilsecolo.lib.fsu.edu/settings.php
cp /vagrant/dependencies/openaccess.settings.php /var/www/html/sites/openaccess.fsu.edu/settings.php
cp /vagrant/dependencies/.htaccess /var/www/html/.htaccess
cat /etc/httpd/conf/httpd.conf | sed -e 's/AllowOverride\ None/AllowOverride\ All/' > /tmp/httpd.conf
rm /etc/httpd/conf/httpd.conf
cp /tmp/httpd.conf /etc/httpd/conf/httpd.conf
service httpd start

/sbin/service mysqld start
chkconfig mysqld on

mysql -e "CREATE DATABASE defaultdb;"
mysql -e "CREATE DATABASE ilsecolodb;"
mysql -e "CREATE DATABASE openaccessdb;"
mysql -e "CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';"
mysql -e "GRANT ALL PRIVILEGES ON defaultdb.* TO dev@localhost;"
mysql -e "GRANT ALL PRIVILEGES ON ilsecolodb.* TO dev@localhost;"
mysql -e "GRANT ALL PRIVILEGES ON openaccessdb.* TO dev@localhost;"
mysql -e "FLUSH PRIVILEGES;"
mysql -u dev --password=dev defaultdb < /vagrant/dependencies/FSULibraries_backrest/default.sql
mysql -u dev --password=dev ilsecolodb < /vagrant/dependencies/FSULibraries_backrest/ilsecolo.sql
mysql -u dev --password=dev openaccessdb < /vagrant/dependencies/FSULibraries_backrest/openaccess.sql
service httpd restart

adduser backrest
