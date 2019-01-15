terraform {
  required_version = "= 0.11.11"
}

provider "aws" {
  version = "1.55.0"
  region  = "${var.AWS_DEFAULT_REGION}"
}

provider "template" {
  version = "1.0.0"
}
