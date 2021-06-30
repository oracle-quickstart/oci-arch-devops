sudo yum -y update; sudo yum -y install httpd; sudo firewall-cmd --permanent --add-port=80/tcp; sudo firewall-cmd --permanent --add-port=443/tcp; sudo firewall-cmd --reload; sudo systemctl start httpd;
sudo echo '<!DOCTYPE html> <html lang="en"> <head> <meta charset="UTF-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>Hello World Service</title> </head> <body> <h1>Hello. Is this the Deployment you are looking for?</h1> <h2>New Deployment - '${version}'</h2> </body> </html>' > /tmp/genericArtifactDemo/output;
sudo touch /var/www/html/index.html;
sudo cp /tmp/genericArtifactDemo/output /var/www/html/index.html;
sudo systemctl stop httpd;
sudo systemctl start httpd;

