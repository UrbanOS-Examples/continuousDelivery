data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  name = "us-east-2"
}
