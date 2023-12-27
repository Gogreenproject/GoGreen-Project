resource "aws_key_pair" "key" {
  key_name   = "${var.prefix}-key"
  public_key = file("~/.ssh/cloud_2024.pem.pub")
}

resource "aws_instance" "Web_Tier" {
  for_each      = var.Web_Tier_ec2
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t4g.nano"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.public_subnets_WT[each.key].id
  vpc_security_group_ids = [module.security-groups.security_group_id["Web_tier_sg"]]
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 
  
  tags = {
    Name = join("_", [var.prefix, each.key])
  }
}

resource "aws_instance" "App_Tier" {
  for_each      = var.App_Tier_ec2
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.small"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.private_subnets_AT[each.key].id
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 
  vpc_security_group_ids = [module.security-groups.security_group_id["App_tier_sg"]]

  tags = {
    Name = join("_", [var.prefix, each.key])
  }
}

resource "aws_instance" "Bastion_Host" {
  for_each      = var.ec2_instance
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.small"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.public_subnets_BS[each.key].id
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 
  vpc_security_group_ids = [module.security-groups.security_group_id["Bastion_host_sg"]]
   user_data              = <<-EOF
                            #!/bin/bash
                            sudo yum update -y
                            sudo yum install -y httpd
                            sudo systemctl start httpd.service
                            sudo systemctl enable httpd.service
                            sudo echo "<h1> HELLO from ${upper(each.key)}_SERVER </h1>" > /var/www/html/index.html                  
                            EOF
  tags = {
    Name = join("_", [var.prefix, each.key])
  }
}

module "security-groups" {
  source  = "app.terraform.io/GoGreen-project/security-groups/aws"
  version = "5.0.0"
  # insert required variables here
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
}

module "vpc" {
  source   = "./vpc/"
  vpc_cidr = "10.0.0.0/20"
}
 
resource "aws_subnet" "public_subnets_BS" {
  for_each          = var.public_subnets_BS
  vpc_id            = module.vpc.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
   map_public_ip_on_launch = true # To ensure the instance gets a public IP

  tags = {
    Name = join("-", [var.prefix, each.key])
  }
}

resource "aws_subnet" "public_subnets_WT" {
  for_each          = var.public_subnets_WT
  vpc_id            = module.vpc.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
   map_public_ip_on_launch = true # To ensure the instance gets a public IP

  tags = {
    Name = join("-", [var.prefix, each.key])
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