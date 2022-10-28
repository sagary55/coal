resource "aws_vpc" "hitachi_vpc" {
  cidr_block           = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "hitachi-vpc",
    Environment = "${var.environment}"
  }
}


resource "aws_subnet" "cidr_public_subnet_a" {
  vpc_id                  = "${aws_vpc.hitachi_vpc.id}"
  cidr_block              = "${var.cidr_public_subnet_a}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.az_a}"
  tags = {
    Name        = "public-a",
    Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.hitachi_vpc]
}
resource "aws_subnet" "cidr_public_subnet_b" {
  vpc_id                  = "${aws_vpc.hitachi_vpc.id}"
  cidr_block              = "${var.cidr_public_subnet_b}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.az_b}"
  tags = {
    Name        = "public-b",
    Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.hitachi_vpc]
}

resource "aws_subnet" "cidr_private_subnet_a" {
  vpc_id     = "${aws_vpc.hitachi_vpc.id}"
  cidr_block = "${var.cidr_private_subnet_a}"
  availability_zone = "${var.az_a}"
  tags = {
    Name        = "private-a",
    Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.hitachi_vpc]
}
resource "aws_subnet" "cidr_private_subnet_b" {
  vpc_id     = "${aws_vpc.hitachi_vpc.id}"
  cidr_block = "${var.cidr_private_subnet_b}"
  availability_zone = "${var.az_b}"
  tags = {
    Name        = "private-b",
    Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.hitachi_vpc]
}

resource "aws_internet_gateway" "hitachi_igateway" {
  vpc_id = "${aws_vpc.hitachi_vpc.id}"
  tags = {
    Name        = "hitachi-igateway"
    Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.hitachi_vpc]
}


resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.hitachi_vpc.id}"
  tags = {
    Name        = "hitachi-public-routetable"
    Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.hitachi_vpc]
}
# Create a route in the route table, to access public via internet gateway
resource "aws_route" "route_igw" {
  route_table_id         = "${aws_route_table.rtb_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.hitachi_igateway.id}"
  depends_on = [aws_internet_gateway.hitachi_igateway]
}


resource "aws_route_table_association" "rta_subnet_association_puba" {
  subnet_id      = "${aws_subnet.cidr_public_subnet_a.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
  depends_on = [aws_route_table.rtb_public]
}
resource "aws_route_table_association" "rta_subnet_association_pubb" {
  subnet_id      = "${aws_subnet.cidr_public_subnet_b.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
  depends_on = [aws_route_table.rtb_public]
}


