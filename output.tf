
output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.image_id 
}

output "aws_ubuntu_ami" {
  value = var.ubuntu_ami  
}

output "server_ip_1" {
    value = aws_instance.demo-server-1.public_ip
}

 output "server_ip_2" {
    value = aws_instance.demo-server-2.public_ip
}

# output "server_ip_3" {
#     value = aws_instance.demo-server-3.public_ip
# }
