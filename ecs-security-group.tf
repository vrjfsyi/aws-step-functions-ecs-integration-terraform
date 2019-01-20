# Create Security Group for ECS Task
resource "aws_security_group" "ecs-task-security-group" {
  name        = "${var.APPLICATION}-${var.ENVIRONMENT}-ecs-task"
  description = "security group for ecs task"
  vpc_id      = "${module.vpc.vpc_id}"

  tags {
    Terraform   = "true"
    Name        = "${var.APPLICATION}-${var.ENVIRONMENT}-ecs-task"
    Application = "${var.APPLICATION}"
    Environment = "${var.ENVIRONMENT}"
  }
}

# Allow all egress traffic
resource "aws_security_group_rule" "ecs-task-egress-all-security-group-rule" {
  type = "egress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]

  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.ecs-task-security-group.id}"
  to_port           = 0
}
