## sg.tf terraform configuration
#

## default security group
#
resource "aws_security_group" "def" {
  name        = "def"
  vpc_id      = aws_vpc.main.id
  description = "def"

  tags = merge(
    var.common_tags,
    {
      Name  = "def"
      Owner = var.prefix
    }
  )

  ## TCP SSH NONSTD IN
  #
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ## ICMP INTERNAL INBOUND PING
  #
  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["10.0.0.0/16"]
  }

  ## EXTERNAL GET TO ANYWHERE all traffic
  #
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ## ICMP INTERNAL INBOUND PING
  #
  egress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_security_group" "tfe" {
  name        = "tfe"
  vpc_id      = aws_vpc.main.id
  description = "tfe"
  tags = merge(
    var.common_tags,
    {
      Name  = "def"
      Owner = var.prefix
    }
  )

  ## TCP SSH NONSTD IN
  #
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8800
    to_port     = 8800
    cidr_blocks = ["0.0.0.0/0"]
  }
}

