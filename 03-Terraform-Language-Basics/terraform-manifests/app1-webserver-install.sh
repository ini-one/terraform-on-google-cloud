#!/bin/bash
set -eux

# Log all output to a file for debugging
exec > /var/log/startup-script.log 2>&1
export DEBIAN_FRONTEND=noninteractive

# Update package list and install required packages
apt-get update -y
apt-get install -y telnet nginx

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Set permissions and create app1 directory
chmod -R 755 /var/www/html
mkdir -p /var/www/html/app1

# Get hostname and IP address
HOSTNAME=$(hostname)
IPADDR=$(hostname -I | awk '{print $1}')

# Define the HTML content
HTML_CONTENT="<!DOCTYPE html>
<html>
  <body style='background-color:rgb(250, 210, 210);'>
    <h1>Welcome to ini-one - WebVM App1</h1>
    <p><strong>VM Hostname:</strong> $HOSTNAME</p>
    <p><strong>VM IP Address:</strong> $IPADDR</p>
    <p><strong>Application Version:</strong> V1</p>
    <p>Google Cloud Platform - Demos</p>
  </body>
</html>"

# Write the HTML content to both index pages
echo "$HTML_CONTENT" > /var/www/html/index.html
echo "$HTML_CONTENT" > /var/www/html/app1/index.html

# #!/bin/bash
# sudo apt-get update
# sudo apt install -y telnet
# sudo apt install -y nginx
# sudo systemctl start nginx
# sudo systemctl enable nginx
# sudo chmod -R 755 /var/www/html
# sudo mkdir -p /var/www/html/app1
# HOSTNAME=$(hostname)
# sudo echo "<!DOCTYPE html> <html> <body style='background-color:rgb(250, 210, 210);'> <h1>Welcome to ini-one - WebVM App1 </h1> <p><strong>VM Hostname:</strong> $HOSTNAME</p> <p><strong>VM IP Address:</strong> $(hostname -I)</p> <p><strong>Application Version:</strong> V1</p> <p>Google Cloud Platform - Demos</p> </body></html>" | sudo tee /var/www/html/app1/index.html
# sudo echo "<!DOCTYPE html> <html> <body style='background-color:rgb(250, 210, 210);'> <h1>Welcome to ini-one - WebVM App1 </h1> <p><strong>VM Hostname:</strong> $HOSTNAME</p> <p><strong>VM IP Address:</strong> $(hostname -I)</p> <p><strong>Application Version:</strong> V1</p> <p>Google Cloud Platform - Demos</p> </body></html>" | sudo tee /var/www/html/index.html
