#!/bin/bash
              sudo su
              #yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo 'Hello World This is prod' >> /var/www/html/index.html
              sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
              systemctl restart httpd
              systemctl restart sshd
