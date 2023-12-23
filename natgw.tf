resource "aws_nat_gateway" "nat" {
  for_each      = var.public_subnets_BS
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public_subnets_BS[each.key].id
  tags = {
    Name        = "nat"
    Environment = "${var.prefix}-nat"
  }
}

resource "aws_eip" "nat" {
  for_each = var.public_subnets_BS
  domain   = "vpc"
}