## vpc.tf terraform configuration
#
## VPC
#
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.prefix}-${var.common_tags.Env}-vpc-${var.aws_region}"
    }
  )
}

## subnets
#
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name   = "${var.prefix}-public-${element(data.aws_availability_zones.available.names, count.index)}"
      Common = "${var.prefix}-public"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
      Name   = "${var.prefix}-private-${element(data.aws_availability_zones.available.names, count.index)}"
      Common = "${var.prefix}-private"
    }
  )
}

## gateways/ips
#
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    { Name = "${var.prefix}-igw" }
  )
}

resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    var.common_tags,
    { Name = "${var.prefix}-nat-eip" }
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.0.id

  depends_on = [
    aws_internet_gateway.main,
    aws_eip.nat_eip,
    aws_subnet.public,
  ]

  tags = merge(
    var.common_tags,
    { Name = "${var.prefix}-ngw" }
  )
}

## s3 endpoint
#
resource "aws_vpc_endpoint" "main" {
  vpc_id            = aws_vpc.main.id
  service_name      = data.aws_vpc_endpoint_service.s3_endpoint.service_name
  vpc_endpoint_type = "Gateway"

  tags = merge(
    var.common_tags,
    { Name = "${var.prefix}-tfe-s3-vpc-endpoint" }
  )
}

resource "aws_vpc_endpoint_route_table_association" "s3_assoc_public" {
  count           = length(var.public_subnet_cidrs)
  vpc_endpoint_id = aws_vpc_endpoint.main.id
  route_table_id  = element(aws_route_table.public.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "s3_assoc_private" {
  count           = length(var.private_subnet_cidrs)
  vpc_endpoint_id = aws_vpc_endpoint.main.id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}
