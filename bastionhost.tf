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