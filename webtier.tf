resource "aws_launch_template" "WEB_lc" {
  name_prefix   = var.prefix
  description   = "Template to launch EC2 instance and deploy the application"
  image_id      = "ami-01450e8988a4e7f44"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
  #key_name               = aws_key_pair.WEB_tier.key_name
  vpc_security_group_ids = [module.security-groups.security_group_id["Web_tier_sg"]]
  # iam_instance_profile {
  #     arn = aws_iam_instance_profile.IAMinstanceprofile.arn
  # }
  user_data = filebase64("application.sh")

}


resource "aws_subnet" "public_subnets_WT" {
  for_each                = var.public_subnets_WT
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true # To ensure the instance gets a public IP

  tags = {
    Name = join("-", [var.prefix, each.key])
  }
}

resource "aws_autoscaling_group" "WEB_asg" {
  vpc_zone_identifier       = [aws_subnet.public_subnets_WT["web_tier_1"].id, aws_subnet.public_subnets_WT["web_tier_2"].id]
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.WEB_tg.arn]
  launch_template {
    id      = aws_launch_template.WEB_lc.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "WEB_att" {
  autoscaling_group_name = aws_autoscaling_group.WEB_asg.id
  lb_target_group_arn    = aws_lb_target_group.WEB_tg.arn
}


resource "aws_autoscaling_policy" "WEB_asg_policy" {
  name                   = "WEB_asg_policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.WEB_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_lb" "WEB_alb" {
  #name_prefix        = var.prefix
  idle_timeout       = 65
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [module.security-groups.security_group_id["Web_tier_sg"]]
  subnets            = [aws_subnet.public_subnets_WT["web_tier_1"].id, aws_subnet.public_subnets_WT["web_tier_2"].id]
}
resource "aws_lb_listener" "WEB_alb_listener_1" {
  load_balancer_arn = aws_lb.WEB_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WEB_tg.arn

  }
}

resource "aws_lb_target_group" "WEB_tg" {
  name        = "web"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    interval            = 200
    timeout             = 60
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200" # has to be HTTP 200 or fails
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 120
  }
}


output "WEB_alb" {
  value = aws_lb.WEB_alb.dns_name
}