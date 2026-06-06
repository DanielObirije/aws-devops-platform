variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnet_cidrs" {}
variable "private_subnet_cdirs" {}
variable "us-availability-zones" {}


output "vpc_id" {
  value =  aws_vpc.main-vpc.id
}

output "public_subent_id" {
  value =  aws_subnet.public_subnet.*.id
}

output "public_subnet_cidr_block" {
  value =  aws_subnet.public_subnet.*.cidr_block 
}

resource "aws_vpc" "main-vpc"{
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "public_subnet"{
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.us-availability-zones, count.index)

  tags = {
    Name = "aws_devops_platform_public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet"{
  count             = length(var.private_subnet_cdirs)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = element(var.private_subnet_cdirs, count.index)
  availability_zone = element(var.us-availability-zones, count.index)

  tags = {
    Name = "aws_devops_platform_private_subnet_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "aws_devops_platform_igw"{
    vpc_id = aws_vpc.main-vpc.id
    tags = {
        Name = "aws_devops_platform_igw"
    }
}

resource "aws_route_table" "aws-devops_platform_public_rt" {
   vpc_id =  aws_vpc.main-vpc.owner_id
   route = {
     cdir_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.aws_devops_platform_igw.id

     tag = {
        Name = "aws_devops_platform_public_rt"
     }
   }
}

resource "aws_route_table_association" "aws-public_rt_subnet_association" {
     count =  length(aws_subnet.public_subnet)
     subnet_id = aws_subnet.public_subnet[count.index].id
     route_table_id =  aws_route_table.aws-devops_platform_public_rt
}

resource "aws_route_table" "aws-devops_platform_private_rt" {
   vpc_id =  aws_vpc.main-vpc.id

   tags = {
      Name = "aws_devops_platform_private_rt"
   }
}

resource "aws_route_table_association" "aws-private_rt_subnet_association" {
     count =  length(aws_subnet.private_subnet)
     subnet_id = aws_subnet.private_subnet[count.index].id
     route_table_id =  aws_route_table.aws-devops_platform_private_rt
}