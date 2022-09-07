#!/bin/bash
installUpdate=`sudo apt update -y >/dev/null 2>&1`
echo $installUpdate
checkPackage=`sudo apt list apache2 | grep apache2 | grep installed >/dev/null 2>&1`
installApcahe=`sudo apt install apache2 >/dev/null 2>&1`


name="Nithin"
filepath="/var/www/html/inventory.html"
if [[ $checkPackage -ne "installed" ]]
then
        echo $installApcahe
        if [ echo $? -eq 0 ]
        then
                echo "Apache installed successfully"
        else
                echo " Apache not installed"
        fi
else
        echo "Apache already present"


fi
serviceStatus=`sudo systemctl status apache2 | grep running >/dev/null 2>&1`
initiateService=`sudo systemctl start apache2 | grep running >/dev/null 2>&1`
apacheServiceActive= `sudo systemctl status apache2 | grep enabled >/dev/null 2>&1`
apacheActivate=`sudo systemctl enable apache2 | grep enabled >/dev/null 2>&1`

if [[ $serviceStatus -ne  "running" ]]
then
         echo $initiateService
        if [ echo $? -eq 0 ]
        then
                echo "service running"
        else
                echo "service not running"
        fi
else
         echo "service running"

fi

if [[ $apacheServiceActive -ne "enabled" ]]
then
	echo $apacheActivate
	if  [ echo $? -eq 0 ]
	then
		echo "Apache installed is enabled"
	else
		echo "Apache not enabled"

	fi
else 
	echo " service is enabled"
fi

apt -s  awscli
if [ $? -ne 0 ];then
	sudo apt install awscli -y
fi

dateLog=$(date +%Y%m%d%H%M%S)
tar -cvf /tmp/$name-httpd-logs-$dateLog.tar /var/log/apache2
aws s3 cp /tmp/$name-httpd-logs-$dateLog.tar  s3://upgrad-nithin

