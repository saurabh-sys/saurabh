resource "aws_vpc_peering_connection" "peering" {
  peer_region = "us-east-1"
  peer_vpc_id = "${aws_vpc.peer_vpc.id}"
  vpc_id = "${aws_vpc.myvpc.id}"
  

}
