# We will create 3 servers with this and use ansible with then
# For ubuntu we will use demo-server-1,
# For amamzon-ami we will use demo-server-1 & demo-server-2

resource "aws_instance" "demo-server-1" {
    ami = var.ubuntu_ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.demo-public-1.id
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    availability_zone = var.availability_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.ssh_key.key_name

    tags = {
      "Name" = "demo-server-1"
    }
 }

 resource "aws_instance" "demo-server-2" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.demo-public-1.id
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    availability_zone = var.availability_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.ssh_key.key_name

    tags = {
      "Name" = "demo-server-2"
    }

    user_data = <<EOF
        #!/bin/bash 
        sudo amazon-linux-extras install epel
        sudo yum update -y
      EOF

  provisioner "local-exec" {
     working_dir = "/mnt/c/Users/prate/OneDrive/Desktop/shell-test/ansible"
     command = "ansible-playbook --inventory ${aws_instance.demo-server-2.public_ip}, --private-key ${var.ssh_key_private} --user ec2-user cent-os-nginx.yaml"
   } 
 }  


resource "aws_instance" "demo-server-3" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.demo-public-1.id
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    availability_zone = var.availability_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.ssh_key.key_name

    tags = {
      "Name" = "demo-server-3"
    }
  
   provisioner "local-exec" {
     working_dir = "/mnt/c/Users/prate/OneDrive/Desktop/shell-test/ansible"
     command = "ansible-playbook --inventory ${aws_instance.demo-server-3.public_ip}, --private-key ${var.ssh_key_private} --user ec2-user cent-os-nginx.yaml"
   } 

 } 

# We are using this resource for demo-server-1
 resource "null_resource" "configure_server" {
    triggers = {
      trigger = aws_instance.demo-server-1.public_ip
    }
  provisioner "local-exec" {
     working_dir = "/mnt/c/Users/prate/OneDrive/Desktop/shell-test/ansible"
     command = "ansible-playbook --inventory ${aws_instance.demo-server-1.public_ip}, --private-key ${var.ssh_key_private} --user ubuntu nginx-install.yaml"
   }
 }