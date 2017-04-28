resource "aws_autoscaling_notification" "notification" {
  group_names = [
    "${aws_autoscaling_group.asg.name}",
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
    "autoscaling:TEST_NOTIFICATION",
  ]

  topic_arn = "${aws_sns_topic.sns.arn}"
}

resource "aws_sns_topic" "sns" {
  name = "${terraform.env}-autoscaling-event-notification"
}

/*
resource "aws_sns_topic_subscription" "sub" {
  topic_arn              = "${aws_sns_topic.sns.arn}"
  protocol               = "lambda"
  endpoint_auto_confirms = true
  endpoint               = ""
}
*/

