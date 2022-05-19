provider "aws" {
  region = "ap-south-1"
  access_key = "~/.aws/credentials"
  secret_key = "~/.aws/credentials"
}

# This will create all VPC for us
resource "aws_vpc" "demo-vpc" {
     cidr_block = var.vpc_cidr_block
     enable_dns_hostnames = true
     enable_dns_support = true
     tags = {
       "Name" = "demo-vpc"
     }
}

# These are all the varibles we are using in this repo, all the values should be stored in tf.tfvars file.
#variable "aws_access_keys" {}
#variable "aws_secret_access_keys" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block_1" {}
variable "subnet_cidr_block_2" {}
variable "my_ip" {}
variable "my_public_key" {}
variable "availability_zone" {}
variable "availability_zone2" {}
variable "availability_zone3" {}
variable "instance_type" {}
variable "ssh_key_private" {}
variable "ubuntu_ami" {}

# Here we will create two public subnets, route table & igw
resource "aws_subnet" "demo-public-1" {
     vpc_id = aws_vpc.demo-vpc.id
     cidr_block = var.subnet_cidr_block_1
     availability_zone = var.availability_zone
     tags = {
       "Name" = "demo-public-1"
     }
}

resource "aws_subnet" "demo-public-2" {
     vpc_id = aws_vpc.demo-vpc.id
     cidr_block = var.subnet_cidr_block_2
     availability_zone = var.availability_zone2
     tags = {
       "Name" = "demo-public-2"
     }
}

resource "aws_internet_gateway" "demo-igw" {
    vpc_id = aws_vpc.demo-vpc.id
    tags = {
     "Name" = "demo-igw"
    }
}

resource "aws_route_table" "demo-vpc-route_table" {
    vpc_id = aws_vpc.demo-vpc.id  

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }

    tags = {
      "Name"  = "demo-igw"
    }
}

resource "aws_route_table_association" "route_table_association" {
    subnet_id = aws_subnet.demo-public-1.id
    route_table_id = aws_route_table.demo-vpc-route_table.id
}

# Now we will create security group with 22 & 80 inbound rules
resource "aws_security_group" "demo-sg" {
    name = "demo-sg"
    vpc_id = aws_vpc.demo-vpc.id
  
    ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }
 
    ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  } 
     
     tags = {
      "Name" = "demo-SG"
    }
}

# This will give us latest amazon-ami image
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
     filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# we will create our own key-pair with this
resource "aws_key_pair" "ssh_key" {
    key_name = "server_demo"
    public_key = var.my_public_key
}



 

