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

resource "aws_route_table_association" "rta_public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.rt_public_BS.id
<<<<<<< HEAD
}
=======
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
#   for_each = var.public_subnets

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat[each.key].id
#   }

#   tags = {
#     Name = "${var.prefix}-rtb-private_at"
#   }
# }

# resource "aws_route_table" "db" {
#   vpc_id = "${aws_vpc.default.id}"

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = "${aws_nat_gateway.default.id}"
#   }

#   tags {
#     Name = "DB"
#   }
# }

>>>>>>> 60e52823b968b55400b0b7356091db19783babb1
