provider "aws" {
#   # Configuration options
  region = var.aws_region 

}

resource "aws_instance" "this" {
  ami                     = local.instance_ami
  instance_type           = var.instance_type
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  key_name = "demo-vpc"
  subnet_id = aws_subnet.public.id

  tags = {
    Name = local.instance_name
  }
  user_data = <<-EOF
              #!/bin/bash
              set -e

              yum update -y
              amazon-linux-extras enable php8.0
              yum clean metadata
              yum install -y httpd php php-mysqlnd mariadb-server wget

              systemctl start httpd
              systemctl enable httpd
              systemctl start mariadb
              systemctl enable mariadb

              DB_NAME="wordpress"
              DB_USER="wpuser"
              DB_PASSWORD="${var.db_password}"

              mysql -e "CREATE DATABASE IF NOT EXISTS $${DB_NAME};"
              mysql -e "CREATE USER '$${DB_USER}'@'localhost' IDENTIFIED BY '$${DB_PASSWORD}';"
              mysql -e "GRANT ALL PRIVILEGES ON $${DB_NAME}.* TO '$${DB_USER}'@'localhost';"
              mysql -e "FLUSH PRIVILEGES;"

              cd /var/www/html
              wget https://wordpress.org/latest.tar.gz
              tar -xzf latest.tar.gz
              cp -r wordpress/* .
              rm -rf wordpress latest.tar.gz

              cp wp-config-sample.php wp-config.php
              sed -i "s/database_name_here/$${DB_NAME}/" wp-config.php
              sed -i "s/username_here/$${DB_USER}/" wp-config.php
              sed -i "s/password_here/$${DB_PASSWORD}/" wp-config.php

              chown -R apache:apache /var/www/html
              systemctl restart httpd
              EOF
    
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

    # Security Group

resource "aws_security_group" "wordpress_sg" {
  
  tags = {
    name = "wordpress-sg"
  }
  description = "Allow HTTP and SSH"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "example" {

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "wordpress-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "wordpress-public-subnet"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "wordpress-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "wordpress-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}