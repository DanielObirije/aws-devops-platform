variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnet_cidrs" {}
variable "private_subnet_cdirs" {}
variable "us-availability-zones" {}


resource "aws_vpc" "main-vpc"{
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "public_subnet"{
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main-vpc.id
  
}