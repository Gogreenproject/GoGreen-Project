resource "aws_instance" "Web_Tier" {
  for_each      = var.Web_Tier_ec2
  ami           = "ami-01450e8988a4e7f44"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name

  subnet_id              = aws_subnet.public_subnets[each.key].id
  vpc_security_group_ids = [module.security-groups.security_group_id["Web_tier_sg"]]
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 
  
  tags = {
    Name = join("_", [var.prefix, each.key])
  }
}

#public subnets for webtier {1,2}, bastion host{1,2}
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true # To ensure the instance gets a public IP

  tags = {
    Name = join("-", [var.prefix, each.key])
  }
}


#Application load balancer 
module "web-alb" {
  source = "./modules/application_load_balancer"
  name   = "tf-webtier-alb"
  #internal           = false
  #load_balancer_type = "application"
  security_groups = [module.sg_alb_web.sg_id]
  subnets         = [module.subnet-pub-1a.subnet_id, module.subnet-pub-1b.subnet_id]

  #enable_deletion_protection = false

  tags_alb = var.tags_alb_web
}


#Listener group
module "http_listener_web" {
  source   = "./modules/listener_group"
  lb_arn   = module.web-alb.alb_arn
  port     = "80"
  protocol = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  tg_arn = module.webTier-tg.tg_arn
}

#Autoscaling 1
module "web_asg1" {
  source              = "./modules/autoscaling_group"
  vpc_zone_identifier = [aws_subnet.public_subnets[web_tier_1].id]
  #  availability_zones = ["us-west-2a"]
  desired_capacity  = 1
  max_size          = 1
  min_size          = 1
  target_group_arns = [module.webTier-tg.tg_arn]
  launch_template   = module.webtier_lt.lt_id

}

#Autoscaling 2
module "web_asg2" {
  source              = "./modules/autoscaling_group"
  vpc_zone_identifier = [aws_subnet.public_subnets[web_tier_2].id]
  #  availability_zones = ["us-west-2b"]
  desired_capacity  = 1
  max_size          = 1
  min_size          = 1
  target_group_arns = [module.webTier-tg.tg_arn]
  launch_template   = module.webtier_lt.lt_id

}