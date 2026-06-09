module "networking" {
  source                = "./networking"
  vpc_cidr              = var.vpc_cidr
  vpc_name              = var.vpc_name
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cdirs  = var.private_subnet_cdirs
  us-availability-zones = var.us-availability-zones
}

module "security_group" {
  source = "./security-groups"
  ec2_sg_name = "SG for Ec2 to Enable  Port 22(SSH), Port 80(HTTP) and Port 443(HTTPS)"
  vpc_id = module.networking.public_subent_id
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

module "jenkins" {
  source = "./jenkins"
  vpc_id = var.vpc_name
  ami_id = var.ec2_ami_id
  instance_type = var.instance_type
  tag_name = "jenkins ubuntu linux ec2"
  public_key = var.public_key
  subnet_id = tolist(module.networking.public_subent_id)[0]
  sg_for_jenkins = [module.security_group.Ec2_public_sg, module.security_group.Jenkins_ec2_public_sg]
  enable_public_ip_address = true
  user_data_install_jenkins = templatefile("./jenkins-runner-scripts/jenkins-installer.sh",{})
}

module "lb_target_group" {
  source = "./load-balancer-target-group"
  lb_target_group_name = "jenkins_lb_target_group"
  lb_target_group_port = 8080
  lb_target_group_protocal = "HTTP"
  vpc_id = module.networking.vpc_id
  ec2_instance_id = module.jenkins.jenkins_ec2_instance_ip
}

module "alb" {
  source = "./load-balancer"
  lb_name = "aws-devops-platform-lb"
  lb_type = "application"
  subnet_ids = tolist(module.networking.public_subent_id)
  is_external = false
  sg_enable_ssh_https = module.security_group.Ec2_public_sg
  lb_listner_port = 80
  lb_listner_protocol = "HTTP"
  lb_listner_default_action = "forward"
  lb_https_listner_port = 443
  lb_https_listner_protocol = "HTTPS"
  lb_target_group_attachment_port = 8080
  platform_acm_arn = "unkonwn"
  lb_target_group_arn = module.lb_target_group.lb_target_group_arn
  ec2_instance_id = module.jenkins.jenkins_ec2_instance_id

}