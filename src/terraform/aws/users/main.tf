provider "aws" {
  region = "${var.region}"
}

resource "aws_iam_user" "user" {
  count         = "${length(var.users)}"
  name          = "${var.users[count.index]}"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "user-login-profile" {
  count                   = "${length(var.users)}"
  user                    = "${var.users[count.index]}"
  pgp_key                 = "keybase:test"
  password_reset_required = true
  depends_on              = ["aws_iam_user.user"]
}

resource "aws_iam_group_membership" "superuser_membership" {
  name       = "${var.group}-membership"
  users      = "${var.users}"
  group      = "${var.group}"
  depends_on = ["aws_iam_user.user"]
}
