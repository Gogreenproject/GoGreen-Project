resource "aws_instance" "App_Tier" {
  for_each      = var.App_Tier_ec2
  ami           = "ami-01450e8988a4e7f44"
  instance_type = "t2.small"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.private_subnets_AT[each.key].id
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 
  vpc_security_group_ids = [module.security-groups.security_group_id["App_tier_sg"]]
  user_data              = <<-EOF
   #!/bin/bash -ex

 {

 # Update the system

 sudo dnf -y update



 # Install MySQL Community Server

 sudo dnf -y install https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm

 sudo dnf -y install mysql-community-server



 # Start and enable MySQL

 sudo systemctl start mysqld

 sudo systemctl enable mysqld



 # Install Apache and PHP

 sudo dnf -y install httpd php



 # Start and enable Apache

 sudo systemctl start httpd

 sudo systemctl enable httpd

 cd /var/www/html

 sudo wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/CUR-TF-200-ACACAD/studentdownload/lab-app.tgz

 sudo tar xvfz lab-app.tgz

 sudo chown apache:root /var/www/html/rds.conf.php

 } &> /var/log/user_data.log
                                                  EOF
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
  source = "./modules/application_load_balancer"
  name   = "tf-apptier-alb"
  security_groups = [module.sg_alb_app.sg_id]
  subnets         = [module.subnet-priv-1a.subnet_id, module.subnet-priv-1b.subnet_id]
  is_internal     = true
  tags_alb = var.tags_alb_app
}

#Target Group
module "appTier-tg" {
  source   = "./modules/target_group"
  name     = "tf-appTier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.my_vpc.my_vpc_id
  tags_tg  = var.tags_app_tg
}

#Listener group 
module "http_listener_app" {
  source   = "./modules/listener_group"
  lb_arn   = module.app-alb.alb_arn
  port     = "80"
  protocol = "HTTP"
  tg_arn = module.appTier-tg.tg_arn
}




#autoscaling 1
module "app_asg1" {
  source              = "./modules/autoscaling_group"
  vpc_zone_identifier = [module.subnet-priv-1a.subnet_id]
  desired_capacity  = 1
  max_size          = 1
  min_size          = 1
  target_group_arns = [module.appTier-tg.tg_arn]
  launch_template   = module.apptier_lt.lt_id


}
#autoscaling 2
module "app_asg2" {
  source              = "./modules/autoscaling_group"
  vpc_zone_identifier = [module.subnet-priv-1b.subnet_id]
  desired_capacity  = 1
  max_size          = 1
  min_size          = 1
  target_group_arns = [module.appTier-tg.tg_arn]
  launch_template   = module.apptier_lt.lt_id


}