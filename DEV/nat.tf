resource "aws_eip" "eip_public_a" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_a" {
  allocation_id = "${aws_eip.eip_public_a.id}"
  subnet_id     = "${aws_subnet.cidr_public_subnet_a.id}"
  tags = {
    Name = "hitachi-nat-public-a"
  }
}

resource "aws_route_table" "rtb_privatea" {
  vpc_id = "${aws_vpc.hitachi_vpc.id}"
  tags = {
    Name        = "hitachi-privatea-routetable"
    Environment = "${var.environment}"
  }
}
resource "aws_route" "route_privatea_nat" {
  route_table_id         = "${aws_route_table.rtb_privatea.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw_public_a.id}"
}
resource "aws_route_table_association" "rta_subnet_association_privatea" {
  subnet_id      = "${aws_subnet.cidr_private_subnet_a.id}"
  route_table_id = "${aws_route_table.rtb_privatea.id}"
}

resource "aws_eip" "eip_public_b" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_b" {
  allocation_id = "${aws_eip.eip_public_b.id}"
  subnet_id     = "${aws_subnet.cidr_public_subnet_b.id}"
  tags = {
    Name = "hitachi-nat-public-b"
  }
}

resource "aws_route_table" "rtb_privateb" {
  vpc_id = "${aws_vpc.hitachi_vpc.id}"
  tags = {
    Name        = "hitachi-privateb-routetable"
    Environment = "${var.environment}"
  }
}
resource "aws_route" "route_privateb_nat" {
  route_table_id         = "${aws_route_table.rtb_privateb.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw_public_b.id}"
}
resource "aws_route_table_association" "rta_subnet_association_privateb" {
  subnet_id      = "${aws_subnet.cidr_private_subnet_b.id}"
  route_table_id = "${aws_route_table.rtb_privateb.id}"
}


//resource "aws_security_group" "webserver_sg" {
  //name   = "webserver_sg"
  //vpc_id = "${aws_vpc.hitachi_vpc.id}"
  //description = "security group for webserver instance"

  //tags = {
    //Name        = "webserver_sg"
    //Environment = "${var.environment}"
  //}
//}


//resource "aws_security_group_rule" "webserver_sg" {
  //type              = "ingress"
  //cidr_blocks       = ["0.0.0.0/0"]
  //to_port           = 0
  //from_port         = 0
  //protocol          = "-1"
  //security_group_id = "${aws_security_group.sg_hitachi.id}"
//}
//resource "aws_security_group_rule" "outbound_allow_all" {
  //type              = "egress"
  //cidr_blocks       = ["0.0.0.0/0"]
  //to_port           = 0
  //from_port         = 0
  //protocol          = "-1"
  //security_group_id = "${aws_security_group.sg_hitachi.id}"
//}