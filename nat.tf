#resource "aws_eip" "nateip" {
#  vpc = true
#}
#
#resource "aws_route" "nat" {
#  route_table_id         = "${aws_route_table.natrtb.id}"
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
#  depends_on             = ["aws_route_table.natrtb"]
#}
#
#resource "aws_route" "natpub" {
#  route_table_id         = "${aws_route_table.natpubrtb.id}"
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id             = "${aws_internet_gateway.igw.id}"
#}
#
#resource "aws_nat_gateway" "nat" {
#  allocation_id = "${aws_eip.nateip.id}"
#  subnet_id     = "${aws_subnet.nat.0.id}"
#  depends_on    = ["aws_internet_gateway.igw"]
#}
#
#resource "aws_route_table" "natrtb" {
#  vpc_id = "${aws_vpc.vpc.id}"
#  tags   = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"natrtb")),map("Env",terraform.env))}"
#}
#
#resource "aws_route_table" "natpubrtb" {
#  vpc_id = "${aws_vpc.vpc.id}"
#  tags   = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"natpubrtb")),map("Env",terraform.env))}"
#}
#
#resource "aws_route_table_association" "pub" {
#  count          = 4
#  subnet_id      = "${element(aws_subnet.subnet.*.id,count.index)}"
#  route_table_id = "${aws_route_table.igwrtb.id}"
#}
#
#resource "aws_route_table_association" "nat_pub" {
#  count          = 2
#  subnet_id      = "${element(aws_subnet.nat.*.id,count.index)}"
#  route_table_id = "${aws_route_table.natpubrtb.id}"
#}

