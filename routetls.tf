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

# resource "aws_route_table_association" "rta_private" {
#   for_each       = var.private_subnets_WT
#   subnet_id      = aws_subnet.private_subnets_WT[each.key].id
#   route_table_id = aws_route_table.rt_private[each.key].id
# }

# resource "aws_route_table" "rt_private" {
#   vpc_id = module.vpc.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat[each.key].id
#   }

#   tags = {
#     Name = "${var.prefix}-rtb-private_wt"
#   }
# }

# resource "aws_route_table_association" "rta_private_at" {
#   for_each       = var.private_subnets_AT
#   subnet_id      = aws_subnet.private_subnets_AT[each.key].id
#   route_table_id = aws_route_table.rt_private_at[each.key].id
# }

# resource "aws_route_table" "rt_private_at" {
#   vpc_id = module.vpc.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat[each.key].id
#   }

#   tags = {
#     Name = "${var.prefix}-rtb-private_at"
#   }
# }

