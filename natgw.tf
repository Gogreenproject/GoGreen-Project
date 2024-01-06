resource "aws_nat_gateway" "nat" {
  for_each      = var.public_subnets_WT
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public_subnets_WT[each.key].id
  tags = {
    Name        = "nat"
    Environment = "${var.prefix}-nat"
  }
}

resource "aws_eip" "nat" {
  for_each = var.public_subnets_WT
  domain   = "vpc"
}

output "my_eip" {
  value = { for k, v in aws_eip.nat : k => v.public_ip }
}