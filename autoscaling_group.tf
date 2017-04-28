variable "group_metrics_collection" {
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

variable "as_max" {
  default = 5
}

variable "as_min" {
  default = 2
}

variable "as_desired" {
  default = 2
}

variable "termination_policies" {
  default = [
    "OldestLaunchConfiguration",
    "OldestInstance",
    "Default",
  ]

  //"ClosestToNextInstanceHour",
  //"NewestInstance",
}

resource "aws_placement_group" "pg" {
  name     = "${terraform.env}-placement-group"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "asg" {
  name_prefix          = "${terraform.env}-asg-"
  max_size             = "${var.as_max}"
  desired_capacity     = "${var.as_desired}"
  min_size             = "${var.as_min}"
  launch_configuration = "${aws_launch_configuration.launch_conf.name}"
  vpc_zone_identifier  = ["${list(aws_subnet.subnet.0.id,aws_subnet.subnet.1.id)}"]
  enabled_metrics      = ["${var.group_metrics_collection}"]

  #  placement_group = "${aws_placement_group.pg.id}"

  termination_policies = ["${var.termination_policies}"]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "${terraform.env}-asg"
    propagate_at_launch = true
  }
  tag {
    key                 = "Env"
    value               = "${terraform.env}"
    propagate_at_launch = true
  }
  depends_on = ["aws_launch_configuration.launch_conf"]
}
