resource "aws_sns_topic" "notify-task-start-sns-topic" {
  name = "${var.APPLICATION}-${var.ENVIRONMENT}-notify-task-start"
}

resource "aws_sns_topic_subscription" "notify-task-start-notify-slack" {
  topic_arn = "${aws_sns_topic.notify-task-start-sns-topic.arn}"

  protocol = "lambda"
  endpoint = "${aws_lambda_function.notify-slack-lambda-function.arn}"
}

resource "aws_sns_topic" "notify-task-success-sns-topic" {
  name = "${var.APPLICATION}-${var.ENVIRONMENT}-notify-task-success"
}

resource "aws_sns_topic_subscription" "notify-task-success-notify-slack" {
    
  topic_arn = "${aws_sns_topic.notify-task-success-sns-topic.arn}"

  protocol = "lambda"
  endpoint = "${aws_lambda_function.notify-slack-lambda-function.arn}"
}

resource "aws_sns_topic" "notify-task-failure-sns-topic" {
  name = "${var.APPLICATION}-${var.ENVIRONMENT}-notify-task-failure"
}

resource "aws_sns_topic_subscription" "notify-task-failure-notify-slack" {
  topic_arn = "${aws_sns_topic.notify-task-failure-sns-topic.arn}"

  protocol = "lambda"
  endpoint = "${aws_lambda_function.notify-slack-lambda-function.arn}"
}
