resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "dedicated"
  enable_dns_hostnames = true

  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "publicsubnet" {
  count = "${length(var.public_subnet_cidr)}"
  vpc_id = "${aws_vpc.myvpc.id}"
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zone, count.index)}"
  tags = {
      Name = "publicsubnet"
  }
  depends_on = ["aws_vpc.myvpc"]
}



resource "aws_subnet" "PrivateSubnet" {
  count = "${length(var.private_subnet_cidr)}"
  vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zone, count.index)}"
  

  tags = {
    Name = "PrivateSubnet"
  }
  depends_on = ["aws_vpc.myvpc"]
}
resource "aws_security_group" "SG" {

  name        = "SG"
  description = "inbound traffic"
  vpc_id      = "${aws_vpc.myvpc.id}"

  ingress = "${var.in_prots}"

  egress = "${var.out_ports}"

  tags = {
    Name = "SG"
  }

  depends_on = ["aws_vpc.myvpc"]

}


resource "aws_internet_gateway" "igw_tf" {
    vpc_id = "${aws_vpc.myvpc.id}"

    tags = {
        Name = "igw_tf"
    }

    depends_on = ["aws_vpc.myvpc"]
  
}

resource "aws_route_table" "vpc_RouteTable" {
    vpc_id = "${aws_vpc.myvpc.id}"

    route {
        cidr_block = "${var.cidr}"
        gateway_id = "${aws_internet_gateway.igw_tf.id}"
    }

    tags = {
        Name = "vpc_RouteTable"
    }

    depends_on = ["aws_vpc.myvpc","aws_internet_gateway.igw_tf"]
  
}

resource "aws_route_table_association" "routetableassociation" {
  count = "${length(var.public_subnet_cidr)}"
  subnet_id = "${element(aws_subnet.publicsubnet.*.id, count.index)}"
  route_table_id  = "${aws_route_table.vpc_RouteTable.id}"
  depends_on = ["aws_subnet.publicsubnet","aws_route_table.vpc_RouteTable"]
}
