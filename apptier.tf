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