# Create Log Group for ECS sample container
resource "aws_cloudwatch_log_group" "ecs-task-sample-cloudwatch-log-group" {
  name = "/${var.APPLICATION}/${var.ENVIRONMENT}/sample"

  retention_in_days = 7

  tags {
    Terraform   = "true"
    Name        = "/${var.APPLICATION}/${var.ENVIRONMENT}/sample"
    Application = "${var.APPLICATION}"
    Environment = "${var.ENVIRONMENT}"
  }
}
