provider "aws" {
  region = "${var.region}"
}

# module "iam_user" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-user"

#   count                   = "${length(var.users)}"
#   name                    = "${var.users[count.index]}"
#   force_destroy           = true
#   pgp_key                 = "keybase:test"
#   password_reset_required = false
# }

resource "aws_iam_user" "user" {
  name          = "test-user"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "user-login-profile" {
  user                    = "${aws_iam_user.user.name}"
  pgp_key                 = "keybase:test"
  password_reset_required = true
}

resource "aws_iam_group_membership" "superuser_membership" {
  name       = "${var.group}-membership"
  users      = "${var.users}"
  group      = "${var.group}"
  depends_on = ["aws_iam_user.user"]
}
