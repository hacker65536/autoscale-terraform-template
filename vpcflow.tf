data "aws_iam_policy_document" "flow_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStream",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "vpcflow" {
  name_prefix        = "${terraform.env}-vpc-flow"
  assume_role_policy = "${data.aws_iam_policy_document.flow_assume_role.json}"
}

resource "aws_iam_role_policy" "vpcflow" {
  name_prefix = "${terraform.env}-vpcflow-policy-"
  role        = "${aws_iam_role.vpcflow.id}"
  policy      = "${data.aws_iam_policy_document.logs.json}"
}

resource "aws_cloudwatch_log_group" "vpcflow" {
  name = "${terraform.env}-vpcflow"
  tags = "${merge(var.tags,map("Name",format("%s-%s",terraform.env,"vpcflow")),map("Env",terraform.env))}"
}

resource "aws_flow_log" "flow" {
  log_group_name = "${aws_cloudwatch_log_group.vpcflow.name}"
  iam_role_arn   = "${aws_iam_role.vpcflow.arn}"
  vpc_id         = "${aws_vpc.vpc.id}"
  traffic_type   = "ALL"
}
