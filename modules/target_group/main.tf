#Target Group
module "appTier-tg" {
  source   = "./modules/target_group"
  name     = "tf-appTier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.my_vpc.my_vpc_id
  tags_tg  = var.tags_app_tg
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