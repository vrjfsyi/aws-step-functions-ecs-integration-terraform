# Create IAM Role and Policy for ECS Task

# Create IAM Assume Role Policy Document
data "aws_iam_policy_document" "ecs-task-assume-role-iam-policy-document" {
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

## Create IAM role for ECS Task
resource "aws_iam_role" "ecs-task-iam-role" {
  name               = "${var.APPLICATION}-${var.ENVIRONMENT}-ecs-task-iam-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-task-assume-role-iam-policy-document.json}"
  path               = "/${var.APPLICATION}/${var.ENVIRONMENT}/"
  description        = "iam role for ecs task"

  tags = {
    Name        = "${var.APPLICATION}-${var.ENVIRONMENT}-ecs-task-iam-role"
    Application = "${var.APPLICATION}"
    Environment = "${var.ENVIRONMENT}"
    Terraform   = "true"
  }
}
