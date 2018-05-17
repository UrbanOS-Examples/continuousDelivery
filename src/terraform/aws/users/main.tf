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
  pgp_key                 = "${var.pgp_key}"
  password_reset_required = true
  depends_on              = ["aws_iam_user.user"]
}

resource "aws_iam_group_membership" "dev-group-membership" {
  name       = "dev-group-membership"
  users      = "${var.users}"
  group      = "${aws_iam_group.dev-group.name}"
  depends_on = ["aws_iam_user.user"]
}

resource "aws_iam_group" "dev-group" {
  name = "developers"
}

resource "aws_iam_group_policy_attachment" "dev-group-policy-AdministratorAccess" {
  group      = "${aws_iam_group.dev-group.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
