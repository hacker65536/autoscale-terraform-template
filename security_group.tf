variable "sec" {
  default = [
    "0.0.0.0/0",
  ]
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"default-sg")))}"
}

resource "aws_security_group" "sec" {
  name        = "${terraform.env}-sec-sg"
  description = "from cy office"
  vpc_id      = "${aws_vpc.vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"sec-sg")))}"
}

resource "aws_security_group_rule" "sec1" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.sec}"]
  security_group_id = "${aws_security_group.sec.id}"
}
