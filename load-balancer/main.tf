variable "lb_name"{}
variable "lb_type" {}
variable "external" {default =  false}
variable "subnet_ids" {}
variable "sg_enable_ssh_https" {}
variable "lb_target_group_arn" {}
variable "ec2_instance_id" {}
variable "lb_listner_port" {}
variable "lb_listner_protocol" {}
variable "lb_listner_default_action" {}
variable "lb_https_listner_port" {}
variable "lb_https_listner_protocol" {}
variable "lb_target_group_attachment_port" {}
variable "platform_acm_arn" {}


output "load_balancer_dns_name" {
  value =  aws_lb.aws-devops-platform_lb.dns_name
}

output "load_balancer_zone_id" {
  value =  aws_lb.aws-devops-platform_lb.zone_id
}


resource "aws_lb" "aws-devops-platform_lb" {
    name =  var.lb_name
    internal =  var.external
    load_balancer_type = var.lb_type
    subnets = var.subnet_ids
    security_groups =  var.sg_enable_ssh_https 
}


resource "aws_lb_target_group_attachment" "public-instace" {
  target_group_arn =  var.lb_target_group_arn
  target_id =  var.ec2_instance_id
  port = var.lb_target_group_attachment_port
}

resource "aws_lb_listener" "http_lb_listener" {
  load_balancer_arn = aws_lb.aws-devops-platform_lb
  port = var.lb_listner_port
  protocol = var.lb_https_listner_protocol

  default_action {
    type = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}

resource "aws_lb_listener" "https_lb_listener" {
  load_balancer_arn = aws_lb.aws-devops-platform_lb
  port = var.lb_https_listner_port
  protocol = var.lb_https_listner_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn =  var.platform_acm_arn
  
  default_action {
    type = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}
