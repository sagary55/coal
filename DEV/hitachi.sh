#!/bin/bash
              sudo su
              #yum update -y
              sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo 'Hello World this is DEV' >> /var/www/html/index.html
              sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              #sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
              systemctl restart httpd
              systemctl restart sshd
