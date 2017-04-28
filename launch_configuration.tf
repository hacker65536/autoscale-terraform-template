variable "as_instance_type" {
  // placment group require c4+     

  //default = "c4.large"

  default = "t2.micro"
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2017.03.0.20170401-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

/* {{{ ami ubuntu  */
#data "aws_ami" "ami" {
#  most_recent = true
#
#  filter {
#    name   = "name"
#    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
#  }
#
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#
#  owners = ["099720109477"]
#}
#
/* }}} */

resource "aws_iam_role" "role" {
  name_prefix        = "${terraform.env}-InstanceRole-"
  assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "ec2ssm" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name_prefix = "${terraform.env}-InstanceRole-"
  role        = "${aws_iam_role.role.name}"
}

resource "aws_launch_configuration" "launch_conf" {
  name_prefix                 = "${terraform.env}-launch-conf-"
  image_id                    = "${data.aws_ami.ami.id}"
  instance_type               = "${var.as_instance_type}"
  key_name                    = "${aws_key_pair.key_pair.key_name}"
  security_groups             = ["${list(aws_default_security_group.default.id,aws_security_group.sec.id)}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.cwd}/user_data")}"
  iam_instance_profile        = "${aws_iam_instance_profile.instance_profile.arn}"

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  #  ebs_block_device {
  #    device_name           = "/dev/xvdcz"
  #    volume_size           = "40"
  #    volume_type           = "gp2"
  #    delete_on_termination = true
  #  }
  lifecycle {
    create_before_destroy = true
  }
}

# vim:set foldmethod=marker:

