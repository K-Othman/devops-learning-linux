# EC2 NGINX Deployment

## Overview

In this project I deployed a web server using AWS EC2 and configured DNS to point my domain to the instance.

## Infrastructure

* EC2 instance running Amazon Linux
* NGINX web server
* Domain configured via Cloudflare DNS

## Steps Completed

1. Created an EC2 instance
2. Configured security groups to allow SSH and HTTP
3. Installed and started NGINX
4. Configured DNS A record pointing to the EC2 public IP
5. Verified domain loads the NGINX landing page

## Commands Used

Install nginx

sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

Connect to server

ssh -i nginx-key.pem ec2-user@EC2_PUBLIC_IP

## What I Learned

* How to deploy infrastructure on AWS
* How DNS records map domains to servers
* Basic Linux server configuration
* Running and managing NGINX

## Challenges

The SSH key initially had incorrect permissions which prevented login.
This was resolved by updating the key permissions:

chmod 400 nginx-key.pem
