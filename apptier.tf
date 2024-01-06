resource "aws_instance" "App_Tier" {
  for_each      = var.App_Tier_ec2
  ami           = "ami-01450e8988a4e7f44"
  instance_type = "t2.small"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.private_subnets_AT[each.key].id
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 
  vpc_security_group_ids = [module.security-groups.security_group_id["App_tier_sg"]]

  tags = {
    Name = join("_", [var.prefix, each.key])
  }
}

resource "aws_subnet" "private_subnets_AT" {
  vpc_id                  = module.vpc.vpc_id
  for_each                = var.private_subnets_AT
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true # To ensure the instance gets a public IP

  tags = {
    Name = each.value.name
  }
}


#Application load balancer 
module "app-alb" {
  source          = "./modules/application_load_balancer"
  name            = "tf-apptier-alb"
  security_groups = [module.sg_alb_app.sg_id]
  subnets         = aws_subnet.private_subnets_AT[each.key].id
  is_internal     = true
  tags_alb        = var.tags_alb_app
}



#Listener group 
module "http_listener_app" {
  source   = "./modules/listener_group"
  lb_arn   = module.app-alb.alb_arn
  port     = "80"
  protocol = "HTTP"
  tg_arn   = module.appTier-tg.tg_arn
}




#autoscaling 1
module "app_asg1" {
  source              = "./modules/autoscaling_group"
  vpc_zone_identifier = [module.subnet-priv-1a.subnet_id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  target_group_arns   = [module.appTier-tg.tg_arn]
  launch_template     = module.apptier_lt.lt_id

}
#autoscaling 2
module "app_asg2" {
  source              = "./modules/autoscaling_group"
  vpc_zone_identifier = [aws_subnet.private_subnets_AT_id]
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  target_group_arns   = [module.appTier-tg.tg_arn]
  launch_template     = module.apptier_lt.lt_id
}