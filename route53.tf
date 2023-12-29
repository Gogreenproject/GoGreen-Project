# main.tf

# provider "aws" {
#   regions = ["us-west-1", "eu-central-1", "sa-east-1"]
# }

# # Function to generate unique names based on the region
# locals {
#   unique_name = {
#     us-west-1    = "uswest1"
#     eu-central-1 = "eucentral1"
#     sa-east-1    = "saeast1"
#   }
# }

# # Function to generate unique CIDR blocks based on the region
# locals {
#   generate_cidr_block = {
#     us-west-1    = "10.4.0.0/16"
#     eu-central-1 = "10.5.0.0/16"
#     sa-east-1    = "10.6.0.0/16"
#   }
# }

# # Create VPCs in different regions
# resource "aws_vpc" "gogreen_vpc" {
#   for_each = local.unique_name

#   cidr_block           = local.generate_cidr_block[each.key]
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "GoGreenVPC-${each.key}"
#   }
# }

# # Create subnets in each region
# resource "aws_subnet" "gogreen_subnet" {
#   for_each = aws_vpc.gogreen_vpc

#   vpc_id            = each.value.id
#   cidr_block        = cidrsubnet(each.value.cidr_block, 8, 1) # Assuming /24 subnets, adjust as needed
#   availability_zone = "${each.key}a"                          # Use the first Availability Zone in each region

#   tags = {
#     Name = "GoGreenSubnet-${each.key}"
#   }
# }

# # Create security groups for the Web, App, and DB tiers
# resource "aws_security_group" "web_sg" {
#   vpc_id = aws_vpc.gogreen_vpc["us-west-1"].id # Using us-west-1 VPC for simplicity

#   # Define inbound and outbound rules as needed

#   # Security Group for Web Tier
#   resource "aws_security_group" "web_sg" {
#     vpc_id = aws_vpc.gogreen_vpc["us-west-1"].id # Using us-west-1 VPC for simplicity

#     # Inbound rules
#     ingress {
#       from_port   = 80
#       to_port     = 80
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere
#     }

#     # Outbound rules
#     egress {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1" # Allow all outbound traffic
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }

# resource "aws_security_group" "app_sg" {
#   vpc_id = aws_vpc.gogreen_vpc["us-west-1"].id

#   # Define inbound and outbound rules as needed
#   # Security Group for App Tier
#   resource "aws_security_group" "app_sg" {
#     vpc_id = aws_vpc.gogreen_vpc["us-west-1"].id

#     # Inbound rules
#     ingress {
#       from_port   = 8080 # Example port for your application
#       to_port     = 8080
#       protocol    = "tcp"
#       cidr_blocks = ["${aws_security_group.web_sg.id}/32"] # Allow traffic only from Web Tier
#     }

#     # Outbound rules
#     egress {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1" # Allow all outbound traffic
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }

# resource "aws_security_group" "db_sg" {
#   vpc_id = aws_vpc.gogreen_vpc["us-west-1"].id

#   # Define inbound and outbound rules as needed
#   # Security Group for DB Tier
#   resource "aws_security_group" "db_sg" {
#     vpc_id = aws_vpc.gogreen_vpc["us-west-1"].id

#     # Inbound rules
#     ingress {
#       from_port   = 3306 # Example port for MySQL
#       to_port     = 3306
#       protocol    = "tcp"
#       cidr_blocks = ["${aws_security_group.app_sg.id}/32"] # Allow traffic only from App Tier
#     }

#     # Outbound rules
#     egress {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1" # Allow all outbound traffic
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }

# # Create RDS instances in each region
# resource "aws_db_instance" "gogreen_db_instance" {
#   for_each = aws_vpc.gogreen_vpc

#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   name                 = "gogreen_db_${each.key}"
#   username             = "gogreen_user"
#   password             = "securepassword"
#   parameter_group_name = "default.mysql5.7"
#   publicly_accessible  = false
#   vpc_security_group_ids = [
#     aws_security_group.db_sg.id,
#   ]
# }

# # Create S3 buckets in each region
# resource "aws_s3_bucket" "gogreen_s3_bucket" {
#   for_each = aws_vpc.gogreen_vpc

#   bucket = "gogreen-documents-${local.unique_name[each.key]}"
#   acl    = "private"

#   versioning {
#     enabled = true
#   }

#   tags = {
#     Name = "GoGreenS3Bucket-${each.key}"
#   }
# }

# # Output information for each region
# output "us_west_1_resources" {
#   value = {
#     vpc_id : aws_vpc.gogreen_vpc["us-west-1"].id,
#     subnet_id : aws_subnet.gogreen_subnet["us-west-1"].id,
#     rds_endpoint : aws_db_instance.gogreen_db_instance["us-west-1"].endpoint,
#     s3_bucket_name : aws_s3_bucket.gogreen_s3_bucket["us-west-1"].bucket,
#     # other outputs...
#   }
# }

# output "eu_central_1_resources" {
#   value = {
#     vpc_id : aws_vpc.gogreen_vpc["eu-central-1"].id,
#     subnet_id : aws_subnet.gogreen_subnet["eu-central-1"].id,
#     rds_endpoint : aws_db_instance.gogreen_db_instance["eu-central-1"].endpoint,
#     s3_bucket_name : aws_s3_bucket.gogreen_s3_bucket["eu-central-1"].bucket,
#     # other outputs...
#   }
# }

# output "sa_east_1_resources" {
#   value = {
#     vpc_id : aws_vpc.gogreen_vpc["sa-east-1"].id,
#     subnet_id : aws_subnet.gogreen_subnet["sa-east-1"].id,
#     rds_endpoint : aws_db_instance.gogreen_db_instance["sa-east-1"].endpoint,
#     s3_bucket_name : aws_s3_bucket.gogreen_s3_bucket["sa-east-1"].bucket,
#     # other outputs...
#   }
# }
