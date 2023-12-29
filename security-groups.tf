#security groups for apptier{1,2}, webtier{1,2}, bastion host {1,2}
module "security-groups" {
  source  = "app.terraform.io/summercloud/security-groups/aws"
  version = "6.0.0"
  # insert required variables here
  # insert required variables here
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
}