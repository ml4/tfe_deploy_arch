## routes
#
# resource "aws_route_table" "private" {
#   count      = length(var.private_subnet_cidrs)
#   vpc_id     = aws_vpc.main.id
#   depends_on = [aws_nat_gateway.main]
#   tags = merge(
#     { Name = "${var.prefix}-private-${count.index}" },
#     var.common_tags
#   )
# }
# resource "aws_route" "private" {
#   count                  = length(var.private_subnet_cidrs)
#   route_table_id         = element(aws_route_table.private.*.id, count.index)
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
# }
# resource "aws_route_table_association" "private" {
#   count          = length(var.private_subnet_cidrs)
#   subnet_id      = element(aws_subnet.private.*.id, count.index)
#   route_table_id = element(aws_route_table.private.*.id, count.index)
# }

resource "aws_route_table" "private" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_nat_gateway.main]

  tags = merge(
    { Name = "${var.prefix}-private" },
    var.common_tags
  )
}
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

