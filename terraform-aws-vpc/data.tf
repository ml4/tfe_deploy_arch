data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc_endpoint_service" "s3_endpoint" {
  service      = "s3"
  service_type = "Gateway"
}
