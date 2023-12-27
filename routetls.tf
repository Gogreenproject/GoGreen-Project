resource "aws_route_table" "rt_public_BS" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-rtb"
  }
}

resource "aws_route_table_association" "rta_public_BS" {
  for_each       = var.public_subnets_BS
  subnet_id      = aws_subnet.public_subnets_BS[each.key].id
  route_table_id = aws_route_table.rt_public_BS.id
}