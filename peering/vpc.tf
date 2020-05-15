resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "dedicated"
  enable_dns_hostnames = true

  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "publicsubnet" {
  
  vpc_id = "${aws_vpc.myvpc.id}"
  cidr_block = "${var.publicsubnet}"
  availability_zone = "${var.avail_zone}"
  tags = {
      Name = "publicsubnet"
  }
  depends_on = ["aws_vpc.myvpc"]
}



resource "aws_subnet" "PrivateSubnet" {
  
  vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "${var.PrivateSubnet}"
  availability_zone = "${var.avail_zone}"
  

  tags = {
    Name = "PrivateSubnet"
  }
  depends_on = ["aws_vpc.myvpc"]
}
resource "aws_security_group" "SG" {

  name        = "SG"
  description = "inbound traffic"
  vpc_id      = "${aws_vpc.myvpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  
  subnet_id = "${aws_subnet.publicsubnet.id}"
  route_table_id  = "${aws_route_table.vpc_RouteTable.id}"
  depends_on = ["aws_subnet.publicsubnet","aws_route_table.vpc_RouteTable"]
}
