provider "aws" {
    region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket         = "scos-terraform-state"
    key            = "nexus"
    region         = "us-east-2"
    dynamodb_table = "terraform_lock"
    encrypt        = "true"
    role_arn       = "arn:aws:iam::784801362222:role/UpdateTerraform"
  }
}

#refer to existing VPC
data "terraform_remote_state" "vpc" {
  backend   = "s3"
  workspace = "${terraform.workspace}"

  config {
    bucket   = "scos-terraform-state"
    key      = "vpc"
    region   = "${var.region}"
    role_arn = "arn:aws:iam::784801362222:role/UpdateTerraform"
  }
}

module "ecs-scalable-cluster" "nexus-cluster" {
  source = "../modules/ecs"
  version = "1.1.4"

  # insert the 10 required variables here

  # Description: This is the ID of the VPC you want to use
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  # Description: List of subnet IDs to use when spinning up your cluster
  # test vpc private subnet
  # VPC computed subnets
  subnet_ids = "${data.terraform_remote_state.vpc.public_subnets}"

  # Description: EC2 Instance Type
  type = "${var.type}"

  # Description: Max number of EC2 instances in the cluster
  cluster_max_size = "${var.cluster_max_size}"

  #Description: Min number of EC2 instances in the cluster
  cluster_min_size = "${var.cluster_min_size}"

  # Description: The name of your ECS cluster
  cluster_name = "${var.cluster_name}"

  # Description: EC2 Instance Profile Name
  instance_profile_name = "${var.instance_profile_name}"

  # Description: AWS Key Pair to use for instances in the cluster
  key_name = "${var.key_name}"

  # Description: Role Name
  role_name = "${var.role_name}"

  # Description: Role Policy Name
  role_policy_name = "${var.role_policy_name}"

  # -----------------------------------------
  # START OF NEW VARIABLES FOR ECS SERVICE/TASKSi

  # Launch control public ip address (true/false)
  launch_control_public_ip = "${var.launch_control_public_ip}"

  # Name of container within load balancer
  container_name = "${var.container_name}"

  # AMI ECS image values/filter
  ami_filter = "${var.ami_filter}"

  # ECS task definition name
  ecs_task_def_name = "${var.ecs_task_def_name}"

  # ECS task definition's docker image
  ecs_task_def_docker_image = "${var.ecs_task_def_docker_image}"

  # ECS task definition's cpu units (max 1024)
  ecs_task_def_cpu_units = "${var.ecs_task_def_cpu_units}"

  # ECS task definition's memory units (max 1024)
  ecs_task_def_memory_units = "${var.ecs_task_def_memory_units}"

  # ECS task definition's memory reservation
  ecs_task_def_memory_reservation = "${var.ecs_task_def_memory_reservation}"

  # ECS service name
  ecs_service_name = "${var.ecs_service_name}"

  ecs_service_tasks_desired_count = "${var.ecs_service_tasks_desired_count}"

  efs_name = "${var.efs_name}"
  efs_token = "${var.efs_token}"
  efs_mode = "${var.efs_mode}"
  efs_encrypted = "${var.efs_encrypted}"

}
