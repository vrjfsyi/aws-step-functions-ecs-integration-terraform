# Create ECS Task Execution Role
data "aws_iam_policy_document" "ecs-task-execution-iam-policy-document" {
  statement {
    sid    = "CreateAndPutLog"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${var.AWS_DEFAULT_REGION}:${data.aws_caller_identity.caller_identity.account_id}:log-group:${aws_cloudwatch_log_group.ecs-task-sample-cloudwatch-log-group.name}",
      "arn:aws:logs:${var.AWS_DEFAULT_REGION}:${data.aws_caller_identity.caller_identity.account_id}:log-group:${aws_cloudwatch_log_group.ecs-task-sample-cloudwatch-log-group.name}:*",
    ]
  }
}

resource "aws_iam_policy" "ecs-task-execution-iam-policy" {
  name        = "${var.APPLICATION}-${var.ENVIRONMENT}-ecs-task-execution"
  policy      = "${data.aws_iam_policy_document.ecs-task-execution-iam-policy-document.json}"
  description = "iam policy for ecs task execution role"
}

data "aws_iam_policy_document" "ecs-task-execution-assume-role-iam-policy-document" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "ecs-task-execution-iam-role" {
  name               = "${var.APPLICATION}-${var.ENVIRONMENT}-ecs-task-execution"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-task-execution-assume-role-iam-policy-document.json}"
  description        = "iam role for ecs task execution"

  path = "/${var.APPLICATION}/${var.ENVIRONMENT}/"

  tags = {
    Name        = "${var.APPLICATION}-${var.ENVIRONMENT}-ecs-task-execution"
    Application = "${var.APPLICATION}"
    Environment = "${var.ENVIRONMENT}"
    Terraform   = "true"
  }
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-iam-role-policy-attachment" {
  role       = "${aws_iam_role.ecs-task-execution-iam-role.name}"
  policy_arn = "${aws_iam_policy.ecs-task-execution-iam-policy.arn}"
}
