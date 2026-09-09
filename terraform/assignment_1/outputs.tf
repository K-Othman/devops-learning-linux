output "instance_id" {
  description = "the id of the ec2 instance"
  value = aws_instance.this.id
}

output "public_ip" {
  description = "the public IP address of the ec2 instance"
  value       = aws_instance.this.public_ip
}