variable "bucket_name"{
    type = string
    description = "Remote state bucket name"
}

variable "vpc_cidr" {
    type = string
    description = "CIDR block for the VPC"
}

variable "vpc_name"{
    type = string
    description = "Name of the VPC"
}

variable "public_subnet_cidrs" {
    type = list(string)
    description = "List of CIDR blocks for public subnets"
}

variable "private_subnet_cdirs"{
    type = list(string)
    description = "List of CIDR blocks for private subnets"
}

variable "us-availability-zones" {
    type = list(string)
    description = "List of availability zones in the region"
}

variable "public_key" {
    type = string
    description = "Public key for EC2 instances"
}

variable "instance_type" {
    type = string
    description = "Ec2 instance type"
}

variable "ec2_ami_id" {
    type = string
    description = "AMI ID for EC2 instances"
}

variable "ec2_sg_name" {
    type = string
    description = "Security group name"
}
