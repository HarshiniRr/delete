#!/bin/bash
sudo apt update
sudo apt install nginx



sudo mkdir -p /var/www/exam.com/html

sudo chown -R $USER:$USER /var/www/exam.com/html

sudo chmod -R 755 /var/www/exam.com



cat > /var/www/exam.com/html/index.html <<EOF
<html>
    <head>
        <title>Welcome to exam.com!</title>
    </head>
    <body>
        <h1>harshini</h1>
    </body>
</html>
EOF

IP=$(curl ipconfig.in/ip)
echo $IP
cat > /etc/nginx/sites-available/exam.com <<EOF 
server {
        listen 80;
        listen [::]:80;
	root /var/www/exam.com/html;
        index index.html index.htm index.nginx-debian.html;

        server_name $IP;

	
        location / {
                try_files $uri/index.html $uri.html $uri/$uri =404;
        }
}
EOF

sed '24 s/#/ /' nginx.conf /etc/nginx/nginx.conf
perl -p -i -e 's/\r//g' /etc/nginx/sites-available/exam.com

sudo ln -s /etc/nginx/sites-available/exam.com /etc/nginx/sites-enabled

sudo nginx -t 
sudo systemctl restart nginx

mkdir /etc/nginx/ssl
openssl req -x 509 -nodes -days 365 \
newkey rsa:2048\
-keyout /etc/nginx/ssl/private.key \
-out /etc/nginx/ssl/private.pem
