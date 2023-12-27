resource "aws_key_pair" "key" {
  key_name   = "$Gogreen-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

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

resource "aws_instance" "App_Tier" {
  for_each      = var.App_Tier_ec2
  ami           = "ami-01450e8988a4e7f44"
  instance_type = "t2.small"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.private_subnets_AT[each.key].id
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 
  vpc_security_group_ids = [module.security-groups.security_group_id["App_tier_sg"]]
  #   #   user_data              = <<-EOF
  #   #                            #!/bin/bash
  #   #                            sudo yum update -y
  #   #                            sudo yum install -y httpd
  #   #                            sudo systemctl start httpd.service
  #   #                            sudo systemctl enable httpd.service
  #   #                            sudo echo "<h1> HELLO from ${upper(each.key)}_SERVER </h1>" > /var/www/html/index.html                  
  #   #                            EOF
  tags = {
    Name = join("_", [var.prefix, each.key])
  }
}

resource "aws_instance" "ec2_instance" {
  for_each      = var.ec2_instance
  ami           = "ami-01450e8988a4e7f44"
  instance_type = "t2.small"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.public_subnets[each.key].id
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

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"

#   name      = "Bastion_Host_1"
#   ami           = "ami-0230bd60aa48260c6"
#   instance_type          = "t2.micro"
#   key_name               = aws_key_pair.key.key_name
#   monitoring             = true
#   vpc_security_group_ids = [module.security-groups.security_group_id["Bastion_host_sg"]]
#   subnet_id              = aws_subnet.public_subnets_BS[each.key].id

#    user_data              = <<-EOF
#                             #!/bin/bash
#                             sudo yum update -y
#                             sudo yum install -y httpd
#                             sudo systemctl start httpd.service
#                             sudo systemctl enable httpd.service
#                             sudo echo "<h1> HELLO from ${upper(each.key)}_SERVER </h1>" > /var/www/html/index.html                  
#                             EOF

#      tags = {
#     Name = join("_", [var.prefix, each.key])
#   }
# }

# module "security-groups" {
#   source          = "app.terraform.io/summercloud/security-groups/aws"
#   version         = "3.0.0"
#   vpc_id          = module.vpc.vpc_id
#   security_groups = var.security_groups
# }

module "security-groups" {
  source  = "app.terraform.io/summercloud/security-groups/aws"
  version = "6.0.0"
  # insert required variables here
  # insert required variables here
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
}

module "vpc" {
  source   = "./vpc/"
  vpc_cidr = "10.0.0.0/20"
}
<<<<<<< HEAD
 
resource "aws_subnet" "public_subnets_BS" {
  for_each          = var.public_subnets_BS
  vpc_id            = module.vpc.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
   map_public_ip_on_launch = true # To ensure the instance gets a public IP
=======

resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true # To ensure the instance gets a public IP
>>>>>>> 60e52823b968b55400b0b7356091db19783babb1

  tags = {
    Name = join("-", [var.prefix, each.key])
  }
}

# resource "aws_subnet" "public_subnets_WT" {
#   for_each          = var.public_subnets_WT
#   vpc_id            = module.vpc.vpc_id
#   cidr_block        = each.value.cidr_block
#   availability_zone = each.value.availability_zone
#    map_public_ip_on_launch = true # To ensure the instance gets a public IP

#   tags = {
#     Name = join("-", [var.prefix, each.key])
#   }
# }

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

# resource "aws_db_instance" "rds" {
#   allocated_storage    = "${var.rds_storage}"
#   engine               = "${var.rds_engine}"
#   instance_class       = "${var.rds_instance_class}"
#   name                 = "${var.rds_name}"
#   username             = "${var.rds_username}"
#   password             = "${var.rds_password}"
#   db_subnet_group_name = "${var.rds_subnet_name}"
# #   depends_on = ["aws_db_subnet_group.rds_subnet_group"]
# }

# resource "aws_subnet" "private_subnets_db" {
#   vpc_id                  = module.vpc.vpc_id
#   for_each                = var.private_subnets_db
#   cidr_block              = each.value.cidr_block
#   availability_zone       = each.value.availability_zone
#   map_public_ip_on_launch = true # To ensure the instance gets a public IP

#   tags = {
#     Name = each.value.name
#   }
# }

# resource "aws_db_subnet_group" "rds_subnet_group" {
#   name       = "${var.rds_subnet_name}"
#   subnet_ids = ["${aws_subnet.private_subnets_db.*.id}"]

#   tags = {
#     Name = rds
#   }
# }

>>>>>>> 60e52823b968b55400b0b7356091db19783babb1
