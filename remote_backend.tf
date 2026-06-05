terraform {
  backend "s3" {
    bucket = "aws-devops-platform-state"
    key    = "aws-devops-platform-key/terraform.tfstate"
    region = "us-east-1"
  }
}