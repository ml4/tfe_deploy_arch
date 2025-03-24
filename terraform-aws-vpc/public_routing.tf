## routes
#
resource "aws_route_table" "public" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    { Name = "${var.prefix}-public" },
    var.common_tags
  )
}
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


