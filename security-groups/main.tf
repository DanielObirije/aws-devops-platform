variable "vpc_id" {}
variable "ec2_sg_name" {}
variable "ec2_jenkins_sg_name" {}

output "Ec2_public_sg" {
  value = aws_security_group.ec2_sg.id
}

output "Jenkins_ec2_public_sg" {
  value = aws_security_group.ec2_jenkins.id
}

resource "aws_security_group" "ec2_sg" {
 name = var.ec2_sg_name
 description = "Enable the Port 22(SSH), Port 80(HTTP) and Port 443(HTTPS)"
 vpc_id = var.vpc_id

 ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
 }

  ingress {
    description = "Allow HTTP from anywhere"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 80
    to_port = 80
    protocol = "tcp"
 }

  ingress {
    description = "Allow HTTPS from anywhere"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 443
    to_port = 443
    protocol = "tcp"
 }

 egress = {
    description = "Allow outgoing request from anywhere"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port = 0
    protocol = "-1"
 }

 tags = {
   Name = "Security group to allow  Port 22(SSH), Port 80(HTTP), Port 443(HTTPS)"
 }
}

resource "aws_security_group" "ec2_jenkins" {
  name =  var.ec2_jenkins_sg_name
  description = "Enable port 8080 for jenkins"
  vpc_id = var.vpc_id
ingress {
    description = "Allow port 8080 to accesss jenkins"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
 }
  tags = {
   Name = "Security group to allow  Port 22(SSH) and Port 80(HTTP) for jenkins,"
 }
}