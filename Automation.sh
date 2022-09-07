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
inventoryFile=/var/www/html/inventory.html
timestamp=$(date +%Y%m%d%H%M%S)

if [ ! -f "$inventoryFile" ]
then
touch "$inventoryFile"
echo "Log Type&emsp;&emsp;&emsp;&emsp;Time Created&emsp;&emsp;&emsp;&emsp;Type&emsp;&emsp;&emsp;&emsp;Size &emsp;<br>" >> "$inventoryFile"
fi
echo "<br>" >> $inventoryFile
echo "<br>httpd-logs &nbsp;&nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp; `du -h /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{print $1}'`" >> /var/www/html/inventory.html


cat /etc/cron.d/automation
echo "* * * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation


