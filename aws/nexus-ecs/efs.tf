resource "aws_efs_file_system" "ecs" {
  creation_token = "nexus"
  # Performance_mode:  generalPurpose, maxIO
  performance_mode = "generalPurpose"
  encrypted = false
  tags {
    Name = "nexus-efs"
  }
}

#resource "aws_efs_mount_target" "a" {
#  file_system_id = "${aws_efs_file_system.cluster.id}"
#  subnet_id      = "${data.aws_subnet_ids[0].private}"
#  security_groups = [
#    "${aws_security_group.allow_all_from_cluster.id}"
#  ]
#}

#resource "aws_efs_mount_target" "b" {
#  file_system_id = "${aws_efs_file_system.cluster.id}"
#  subnet_id      = "${module.vpc.private_subnets[1]}"
#  security_groups = [
#    "${aws_security_group.allow_all_from_cluster.id}"
#  ]
#}

#resource "aws_efs_mount_target" "c" {
#  file_system_id = "${aws_efs_file_system.cluster.id}"
#  subnet_id      = "${module.vpc.private_subnets[2]}"
#  security_groups = [
#    "${aws_security_group.allow_all_from_cluster.id}"
#  ]
#}
