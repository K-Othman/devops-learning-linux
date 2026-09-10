variable "aws_region" {
  type = string
  default = "eu-west-2"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

locals {
  aws_ami = data.aws_ami.amazon_linux.id
  instance_name = "nginx-instance"
}