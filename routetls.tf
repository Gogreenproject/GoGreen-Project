resource "aws_route_table" "rt_public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-rtb"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = module.vpc.vpc_id
  for_each = var.public_subnets

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = {
    Name = "${var.prefix}-rtb-private"
  }
}

resource "aws_route_table_association" "rta_public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rta_private" {
   for_each = local.private_mapping
   subnet_id      = aws_subnet.private_subnets_AT[each.value].id
   route_table_id = aws_route_table.rt_private[each.key].id
}


locals {
  private_mapping = {
    "app_tier_1" = "web_tier_1",
    "app_tier_2" = "web_tier_2"
  }
}

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
