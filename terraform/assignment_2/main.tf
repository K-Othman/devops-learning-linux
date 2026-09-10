# --- PROVIDER ---
# Tells Terraform which cloud and region to talk to.
# eu-west-2 (London) because that's where your key pair and AWS CLI default live.
provider "aws" {
  region = var.aws_region 
}

# --- AMI LOOKUP ---
# Finds the latest Amazon Linux 2 AMI dynamically instead of hardcoding
# a region-specific AMI ID that would go stale or break in other regions.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "this" {
  ami           = local.aws_ami
  instance_type = var.instance_type
  key_name = "demo-vpc"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  subnet_id = aws_subnet.public.id
  user_data = file("nginx-cloud-init.yaml")

  tags = {
    Name = local.instance_name
  }
}

# Creating Security Group
resource "aws_security_group" "nginx_sg" {
  
  tags = {
    name = "Nginx-sg"
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

# Creating VPC 
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "nginx-vpc"
  }
}

# Creating subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "nginx-subnet"
  }
}

# creating internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "nginx-igw"
  }
}

# Route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "nginx-public-rt"
  }
}

# associating the route table to the subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}