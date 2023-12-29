resource "aws_instance" "Web_Tier" {
  for_each      = var.Web_Tier_ec2
  ami           = "ami-01450e8988a4e7f44"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name

  subnet_id              = aws_subnet.public_subnets[each.key].id
  vpc_security_group_ids = [module.security-groups.security_group_id["Web_tier_sg"]]
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 

                             user_data = <<-EOF
                             #!/bin/bash
                             sudo yum update -y
                             sudo systemctl start httpd.service
                             sudo systemctl enable httpd.service
                             sudo echo "<h1> HELLO from ${upper(each.key)}_SERVER </h1>" > /var/www/html/index.html    
                             sudo yum -y install httpd php mysql php-mysql
                             sudo chkconfig httpd on
                             sudo if [ ! -f /var/www/html/lab-app.tgz ]; then
                             sudo cd /var/www/html
                             sudo wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/CUR-TF-200-ACACAD/studentdownload/lab-app.tgz
                             sudo tar xvfz lab-app.tgz
                             sudo chown apache:root /var/www/html/rds.conf.php
                             sudo fi              
                            EOF
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

#Target group
module "webTier-tg" {
  source   = "./modules/target_group"
  name     = "tf-webTier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.my_vpc.my_vpc_id
  tags_tg  = var.tags_web_tg
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
  vpc_zone_identifier = [module.subnet-pub-1a.subnet_id]
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
  vpc_zone_identifier = [module.subnet-pub-1b.subnet_id]
  #  availability_zones = ["us-west-2b"]
  desired_capacity  = 1
  max_size          = 1
  min_size          = 1
  target_group_arns = [module.webTier-tg.tg_arn]
  launch_template   = module.webtier_lt.lt_id

}