# tagging default_route_table
resource "aws_default_route_table" "defrtb" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
  tags                   = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"defrtb")),map("Env",terraform.env))}"
}

resource "aws_route_table" "igwrtb" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"igwrtb")),map("Env",terraform.env))}"
}

resource "aws_route" "igw" {
  route_table_id         = "${aws_route_table.igwrtb.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "pub" {
  count          = 4
  subnet_id      = "${element(aws_subnet.subnet.*.id,count.index)}"
  route_table_id = "${aws_route_table.igwrtb.id}"
}
