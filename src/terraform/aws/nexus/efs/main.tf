provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
   bucket = "scos-terraform-state"
   key    = "nexus_efs"
   region = "us-east-2"
   dynamodb_table="terraform_lock"
   encrypt = "true"
   role_arn = "arn:aws:iam::784801362222:role/UpdateTerraform"
 }
}

module "efs" {
  source = "../modules/efs"

  efs_name = "${var.efs_name}"
  efs_mode = "${var.efs_mode}"
  efs_encrypted = "${var.efs_encrypted}"
  prevent_destroy = "${var.prevent_destroy}"
}
