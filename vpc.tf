#{{{ var
variable "cidr" {
  default = "10.0.0.0/16"
}

variable "enable_dns_support" {
  default = "true"
}

variable "enable_dns_hostnames" {
  default = "true"
}

#}}}

data "aws_availability_zones" "azs" {}

data "aws_region" "reg" {
  current = true
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"vpc")),map("Env",terraform.env))}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"igw")),map("Env",terraform.env))}"
}

resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name         = "${var.pj_prefix}.local ${data.aws_region.reg.name  == "us-east-1" ? format("%s","ec2.internal") : format("%s.compute.internal",data.aws_region.reg.name)}"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags                = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"dhcp")),map("Env",terraform.env))}"
}

resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = "${aws_vpc.vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp.id}"
}

# vim:set foldmethod=marker:

