resource "aws_instance" "Web_Tier" {
  for_each      = var.Web_Tier_ec2
  ami           = "ami-01450e8988a4e7f44"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name

  subnet_id              = aws_subnet.public_subnets[each.key].id
  vpc_security_group_ids = [module.security-groups.security_group_id["Web_tier_sg"]]
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2023_sg"]] 

  user_data = file("web.sh")
  tags = {
    Name = join("_", [var.prefix, each.key])
  }
}