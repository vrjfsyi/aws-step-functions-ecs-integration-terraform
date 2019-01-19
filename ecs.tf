# Create ECS Cluster
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.APPLICATION}-${var.ENVIRONMENT}-cluster"
}
