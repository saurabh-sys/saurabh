
  resource "aws_vpc" "peer_vpc" {
    cidr_block           = "20.0.0.0/24"
  instance_tenancy     = "dedicated"
  enable_dns_hostnames = true

  tags = {
    Name = "peer_vpc"
  }
}

resource "aws_subnet" "publicsubnet_A" {
  count = "${length(var.public_subnet_cidr)}"
  vpc_id = "${aws_vpc.peer_vpc.id}"
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zone, count.index)}"
  tags = {
      Name = "publicsubnet_A"
  }
  depends_on = ["aws_vpc.peer_vpc"]
}



resource "aws_subnet" "PrivateSubnet_A" {
  count = "${length(var.private_subnet_cidr)}"
  vpc_id     = "${aws_vpc.peer_vpc.id}"
  cidr_block = "${element(var.private_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zone, count.index)}"
  

  tags = {
    Name = "PrivateSubnet_A"
  }
  depends_on = ["aws_vpc.peer_vpc"]
}
resource "aws_security_group" "S_G" {

  name        = "S_G"
  description = "allow inbound traffic"
  vpc_id      = "${aws_vpc.peer_vpc.id}"

  ingress = "${var.in_prots}"

  egress = "${var.out_ports}"

  tags = {
    Name = "S_G"
  }

  depends_on = ["aws_vpc.peer_vpc"]

}


resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.peer_vpc.id}"

    tags = {
        Name = "igw"
    }

    depends_on = ["aws_vpc.peer_vpc"]
  
}

resource "aws_route_table" "peer_RouteTable" {
    vpc_id = "${aws_vpc.peer_vpc.id}"

    route {
        cidr_block = "${var.cidr}"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }

    tags = {
        Name = "peer_RouteTable"
    }

    depends_on = ["aws_vpc.peer_vpc","aws_internet_gateway.igw"]
  
}

resource "aws_route_table_association" "peerroutetableassociation" {
  count = "${length(var.private_subnet_cidr)}"
  subnet_id = "${element(aws_subnet.PrivateSubnet_A.*.id, count.index)}"
  route_table_id  = "${aws_route_table.peer_RouteTable.id}"
  
}


