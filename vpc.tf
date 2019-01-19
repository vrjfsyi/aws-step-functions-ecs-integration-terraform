data "aws_availability_zones" "availability_zones" {}

locals {
  cidr               = "192.168.0.0/16"
  availability_zones = ["${data.aws_availability_zones.availability_zones.names}"]
  private_subnets    = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  public_subnets     = ["192.168.10.0/24", "192.168.11.0/24", "192.168.12.0/24"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.46.0"

  name = "${var.APPLICATION}-${var.ENVIRONMENT}"
  cidr = "${local.cidr}"

  azs = "${local.availability_zones}"

  private_subnets = "${local.private_subnets}"
  public_subnets  = "${local.public_subnets}"

  public_subnet_suffix  = "public"
  private_subnet_suffix = "private"

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Name        = "${var.APPLICATION}-${var.ENVIRONMENT}"
    Environment = "${var.ENVIRONMENT}"
    Application = "${var.APPLICATION}"
  }

  private_subnet_tags {
    subnet_type = "private"
  }

  public_subnet_tags {
    subnet_type = "public"
  }

  private_route_table_tags = {
    subnet_type = "private"
  }

  public_route_table_tags = {
    subnet_type = "public"
  }
}
