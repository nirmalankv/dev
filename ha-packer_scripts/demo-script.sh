#!/bin/bash
#pwd
sudo yum install -y httpd
echo "Hello..Good morning" > health_check.html
sudo mv health_check.html /var/www/html/health_check.html
sudo service httpd start
sudo service httpd status
sudo chown -R ec2-user /var/
cd /etc/init.d
sudo chkconfig --add httpd
sudo chkconfig httpd on

#cd
#pwd
#cd ../../../var/www/html
#sudo su
#cd /var/www/html
#cd ../../../
#set -x
#echo "Hello..Good morning" > index.html
#pwd
