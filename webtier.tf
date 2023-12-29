resource "aws_instance" "Web_Tier" {
  for_each      = var.Web_Tier_ec2
  ami           = "ami-01450e8988a4e7f44"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name

  subnet_id              = aws_subnet.public_subnets[each.key].id
  vpc_security_group_ids = [module.security-groups.security_group_id["Web_tier_sg"]]
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 

  user_data = <<-EOF
                              #!/bin/bash -ex
                            {
                            # Update the system
                            sudo dnf -y update
                            # Install MySQL Community Server
                            sudo dnf -y install https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
                            sudo dnf -y install mysql-community-server
                            # Start and enable MySQL
                            sudo systemctl start mysqld
                            sudo systemctl enable mysqld
                            # Install Apache and PHP
                            sudo dnf -y install httpd php
                            # Start and enable Apache
                            sudo systemctl start httpd
                            sudo systemctl enable httpd
                            cd /var/www/html
                            sudo wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/CUR-TF-200-ACACAD/studentdownload/lab-app.tgz
                            sudo tar xvfz lab-app.tgz
                            sudo chown apache:root /var/www/html/rds.conf.php
                            } &> /var/log/user_data.log            
                            EOF
  tags = {
    Name = join("_", [var.prefix, each.key])
  }
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