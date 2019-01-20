
data "archive_file" "notify-slack-archive-file" {
  type = "zip"
  source_dir = "functions/bin/notify-slack"
  output_path = "upload/notify-slack.zip"
}


resource "aws_lambda_function" "notify-slack-lambda-function" {
  filename = "${data.archive_file.notify-slack-archive-file.output_path}"
  function_name = "${var.APPLICATION}-${var.ENVIRONMENT}-notify-slack"
  role = "${aws_iam_role.notify-slack-lambda-iam-role.arn}"
  memory_size = 128
  runtime = "go1.x"
  timeout = 30
  publish = true
  handler = "notify-slack"

  source_code_hash = "${data.archive_file.notify-slack-archive-file.output_base64sha256}"

  environment {
    variables {
      INCOMING_WEBHOOK_URL = "${var.INCOMING_WEBHOOK_URL}"
    }
  }

  tags {
    Terraform = "true"
    Name = "${var.APPLICATION}-${var.ENVIRONMENT}-notify-slack"
    Application = "${var.APPLICATION}"
    Environment = "${var.ENVIRONMENT}"
  }
}


resource "aws_cloudwatch_log_group" "notify-slack-cloudwatch-log-group" {

  name = "/aws/lambda/${aws_lambda_function.notify-slack-lambda-function.function_name}"

  retention_in_days = 7

  tags {
    Terraform = "true"
    Name = "/aws/lambda/${aws_lambda_function.notify-slack-lambda-function.function_name}"
    Application = "${var.APPLICATION}"
    Environment = "${var.ENVIRONMENT}"
  }
}


data "aws_iam_policy_document" "notify-slack-lambda-iam-policy-document" {

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.notify-slack-cloudwatch-log-group.arn}",
    ]
  }
}

resource "aws_iam_policy" "notify-slack-lambda-iam-policy" {
  name = "${var.APPLICATION}-notify-slack-lambda"
  path = "/"
  policy = "${data.aws_iam_policy_document.notify-slack-lambda-iam-policy-document.json}"
}

data "aws_iam_policy_document" "notify-slack-lambda-iam-assume-role-policy-document" {

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      identifiers = [
        "lambda.amazonaws.com",
      ]

      type = "Service"
    }
  }
}

resource "aws_iam_role" "notify-slack-lambda-iam-role" {
  name = "${var.APPLICATION}-notify-slack-lambda"
  assume_role_policy = "${data.aws_iam_policy_document.notify-slack-lambda-iam-assume-role-policy-document.json}"
}


resource "aws_iam_role_policy_attachment" "notify-slack-lambda-iam-role-policy-attachment" {
  policy_arn = "${aws_iam_policy.notify-slack-lambda-iam-policy.arn}"
  role = "${aws_iam_role.notify-slack-lambda-iam-role.name}"
}

resource "aws_lambda_permission" "allow-execution-from-notify-task-start" {
  statement_id = "AllowExecutionFromNotifyTaskStartSNSTopic"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.notify-slack-lambda-function.function_name}"
  principal = "sns.amazonaws.com"
  source_arn = "${aws_sns_topic.notify-task-start-sns-topic.arn}"
}

resource "aws_lambda_permission" "allow-execution-from-notify-task-success" {
  statement_id = "AllowExecutionFromNotifyTaskSuccessSNSTopic"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.notify-slack-lambda-function.function_name}"
  principal = "sns.amazonaws.com"
  source_arn = "${aws_sns_topic.notify-task-success-sns-topic.arn}"
}

resource "aws_lambda_permission" "allow-execution-from-notify-task-failure" {
  statement_id = "AllowExecutionFromNotifyTaskFailureSNSTopic"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.notify-slack-lambda-function.function_name}"
  principal = "sns.amazonaws.com"
  source_arn = "${aws_sns_topic.notify-task-failure-sns-topic.arn}"
}
