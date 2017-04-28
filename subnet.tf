variable "az_suffix" {
  default = [
    "a",
    "b",
  ]
}

resource "aws_subnet" "nat" {
  count             = "2"
  cidr_block        = "${cidrsubnet(aws_vpc.vpc.cidr_block,8,count.index)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${data.aws_availability_zones.azs.names[count.index%2]}"
  tags              = "${merge(var.tags,map("Name",format("%s-%s-%d%s",terraform.env,"nat",count.index/2,var.az_suffix[count.index%2])))}"
}

resource "aws_subnet" "subnet" {
  count             = "4"
  cidr_block        = "${cidrsubnet(aws_vpc.vpc.cidr_block,8,count.index+2)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${data.aws_availability_zones.azs.names[count.index%2]}"
  tags              = "${merge(var.tags,map("Name",format("%s-%s-%d%s",terraform.env,"front",count.index/2,var.az_suffix[count.index%2])))}"
}
