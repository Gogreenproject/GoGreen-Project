output "vpc_id" {
  value = module.vpc.vpc_id
}

output "igw_id" {
  value = aws_internet_gateway.igw_id
}

output "eip_id" {
  value = aws_eip.nat_id
}

output "nat_id" {
  value = aws_nat_gateway.nat_id
}

output "public_rt_id" {
  value = aws_route_table.rt_public_id
}

output "private_rt_id" {
  value = aws_route_table.rt_private_id
}

##Web tier
output "subnet-pubs-id" {
  value = aws_subnet.public_subnets_id
}

# output "subnet-pub-1b-id" {
#   value = module.subnet-pub-1b.subnet_id
# }

output "sg_alb_web_id" {
  value = module.sg_alb_web.sg_id
}

output "web-alb_arn" {
  value = module.web-alb.alb_arn
}

output "webTier-tg-arn" {
  value = module.webTier-tg.tg_arn
}

output "webtier_lt-id" {
  value = module.webtier_lt.lt_id
}

##App Tier 

output "subnet-priv-id" {
  value = aws_subnet.private_subnets_AT
}

# output "subnet-priv-1b-id" {
#   value = module.subnet-priv-1b.subnet_id
# }

output "sg_alb_app_id" {
  value = module.sg_alb_app.sg_id
}

output "app-alb_arn" {
  value = module.app-alb.alb_arn
}

output "appTier-tg-arn" {
  value = module.appTier-tg.tg_arn
}

output "apptier_lt-id" {
  value = module.apptier_lt.lt_id
}

#Data Tier

output "subnet-rds-priv-1a-id" {
  value = module.subnet-rds-priv-1a.subnet_id
}

output "subnet-rds-priv-1b-id" {
  value = module.subnet-rds-priv-1b.subnet_id
}

output "sg_rds_id" {
  value = module.sg_rds.sg_id
}

output "subnet_group_id" {
  value = module.db_subnet_group.subnet_group_id
}

