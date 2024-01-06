resource "aws_instance" "ec2_instance" {
  ami           = "ami-01450e8988a4e7f44"
  instance_type = "t2.small"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.public_subnets_WT["web_tier_1"].id
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 
  vpc_security_group_ids = [module.security-groups.security_group_id["Bastion_host_sg"]]
  tags = {
    Name = join("_", [var.prefix])
  }
}