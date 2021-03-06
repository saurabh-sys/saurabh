
  resource "aws_vpc" "peer_vpc" {
    cidr_block           = "20.0.0.0/16"
  instance_tenancy     = "dedicated"
  enable_dns_hostnames = true

  tags = {
    Name = "peer_vpc"
  }
}

resource "aws_subnet" "subnet_A" {

  vpc_id = "${aws_vpc.peer_vpc.id}"
  cidr_block = var.subnet_A
  availability_zone = var.A_Z
  tags = {
      Name = "subnet_A"
  }
  depends_on = ["aws_vpc.peer_vpc"]
}



resource "aws_subnet" "Private_A" {
  
  vpc_id     = "${aws_vpc.peer_vpc.id}"
  cidr_block = "${var.Private_A}"
  availability_zone = "${var.A_Z}"
  

  tags = {
    Name = "Private_A"
  }
  depends_on = ["aws_vpc.peer_vpc"]
}
resource "aws_security_group" "S_G" {

  name        = "S_G"
  description = "allow inbound traffic"
  vpc_id      = aws_vpc.peer_vpc.id

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
  
  subnet_id = "${aws_subnet.subnet_A.id}"
  route_table_id  = "${aws_route_table.peer_RouteTable.id}"
  
}


