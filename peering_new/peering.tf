resource "aws_vpc_peering_connection" "peering" {
  peer_region = "us-east-1"
  peer_vpc_id = "${aws_vpc.peer_vpc.id}"
  vpc_id = "${aws_vpc.myvpc.id}"
  tags = {
    Name = "peering"
  }
  depends_on = ["aws_vpc.peer_vpc", "aws_vpc.peer_vpc"]

}

resource "aws_vpc_peering_connection_accepter" "conn_accepter" {
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering.id}"
  auto_accept = true
  tags = {
    Name = "conn_accepter"
  }
  depends_on = ["aws_vpc_peering_connection.peering"]
}
