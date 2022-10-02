# !/bin/bash

# Variables
name="Shivam"
s3_bucket="upgrad-shivam"

echo "####TASK-2####"

# update the ubuntu repositories
apt update -y
echo "#ubuntu repositories updated successfully"

# Check if apache2 is installed
if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]]; then
	#statements
	apt install apache2 -y
echo "#apache2 is installed"
fi

# Ensures that apache2 service is running
running=$(systemctl status apache2 | grep active | awk '{print $3}' | tr -d '()')
if [[ running != ${running} ]]; then
	#statements
	systemctl start apache2
	echo "#apache2 service is running"
fi

# Ensures apache2 Service is enabled
enabled=$(systemctl is-enabled apache2 | grep "enabled")
if [[ enabled != ${enabled} ]]; then
	#statements
	systemctl enable apache2
	echo "#apache2 Service is enabled"
fi

# Creating file name
timestamp=$(date '+%d%m%Y-%H%M%S')

# Create tar archive of apache2 access and error logs
cd /var/log/apache2
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log
echo "#tar archive of apache2 access and error logs created successfully"

# copy logs to s3 bucket
if [[ -f /tmp/${name}-httpd-logs-${timestamp}.tar ]]; then
	#statements
	aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
echo "#logs to s3 bucket copied successfully"
fi

echo "#script executed successfully"
