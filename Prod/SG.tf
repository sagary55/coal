resource "aws_security_group" "Hitachi-PROD" {
  name        = "Hitachi-PROD"
  description = "Hitachi-PROD"
  vpc_id      = "vpc-0a9f11ae4c267aa39"




  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
	cidr_blocks      = ["0.0.0.0/0"]
  description      = "internal VPC"
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
	cidr_blocks      = ["0.0.0.0/0"]
  description      = "internal VPC"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Hitachi-PROD"
Environment = "PROD"
Application_Owner = "Hitachi"
Cost_Center = "Production"
Application_Name = "Web"
Partner_Name = "ACC"
Department = "Infra"
}
}
