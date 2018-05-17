provider "aws" {
  region = "${var.region}"
}

module "iam_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

#  count         = ""
  name          = "test.user"
  force_destroy = true
  pgp_key       = "keybase:test"
  password_reset_required = false
}

resource "aws_iam_group_membership" "superuser_membership" {
  name = "${var.group}-membership"
  users = "${var.users}"
  group = "${var.group}"
  depends_on = ["module.iam_user"]
}
