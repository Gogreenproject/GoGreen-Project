#key_pair
resource "aws_key_pair" "key" {
  key_name   = "$Gogreen-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


#security groups for apptier{1,2}, webtier{1,2}, bastion host {1,2}
module "security-groups" {
  source  = "app.terraform.io/summercloud/security-groups/aws"
  version = "6.0.0"
  # insert required variables here
  # insert required variables here
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
}

#vpc module
module "vpc" {
  source   = "./vpc/"
  vpc_cidr = "10.0.0.0/20"
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

