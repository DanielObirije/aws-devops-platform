variable "lb_target_group_name" {}
variable "vpc_id" {}
variable "lb_target_group_protocal" {}
variable "lb_target_group_port" {}
variable "ec2_instance_id" {}

output "lb_target_group_arn" {
  value = aws_lb_target_group.target_group
}

resource "aws_lb_target_group" "target_group" {
  name = var.lb_target_group_name
  vpc_id = var.vpc_id
  port = var.lb_target_group_port
  protocol = var.lb_target_group_protocal
  health_check {
    path = "/login"
    protocol = 8080
    matcher = "200"
    interval = 5
    timeout =  2
    healthy_threshold = 6
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "public-instace" {
  target_group_arn = aws_lb_target_group.target_group
  target_id =  var.ec2_instance_id
  port = 8080
}