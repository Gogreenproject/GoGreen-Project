resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc"
  }
}

variable "vpc_cidr" {
  type = string
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}