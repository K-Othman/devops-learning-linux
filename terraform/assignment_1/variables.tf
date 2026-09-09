variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}


locals {
  instance_ami = data.aws_ami.amazon_linux.id
  instance_name = "Assignment_1"
}

variable "db_password" {
  type      = string
  sensitive = true
}