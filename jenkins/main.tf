variable "ami_id" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "instance_type" {}
variable "sg_for_jenkins" {}
variable "public_key" {}
variable "tag_name" {}
variable "enable_public_ip_address" {}
variable "user_data_install_jenkins" {}

output "ssh_connection_string_for_ec2" {
  value = format("%s%s","ssh -i /Users/ubuntu/.ssh/aws_ec2_terraform ubuntu@",aws_instance.jenkins_ec2_instance.public_ip)
}

output "jenkins_ec2_instance_ip" {
   value = aws_instance.jenkins_ec2_instance.id
}

output "jenkins_ec2_instance_public_ip" {
   value = aws_instance.jenkins_ec2_instance.public_ip
}

resource "aws_instance" "jenkins_ec2_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = var.public_key
  vpc_security_group_ids = var.vpc_id
  associate_public_ip_address = var.enable_public_ip_address
  user_data = var.user_data_install_jenkins
  
  tags = {
    Name = var.tag_name
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }
}