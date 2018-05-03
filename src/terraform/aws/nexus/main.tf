provider "aws" {
    region = "us-east-2"
}

variable "vpc_id" {
  description = "This is the ID of the VPC you want to use"
#  default = "vpc-619efd09"
  default = "vpc-5d006f35"
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
    region   = "us-east-2"
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
  #subnet_ids = ["${split(",",data.terraform_remote_state.vpc.private_subnets)}"]
  subnet_ids = "${data.terraform_remote_state.vpc.private_subnets}"

  # Description: EC2 Instance Type
  type = "t2.large"

  # Description: Max number of EC2 instances in the cluster
  cluster_max_size = 1

  #Description: Min number of EC2 instances in the cluster
  cluster_min_size = 1

  # Description: The name of your ECS cluster
  cluster_name = "nexus-cluster"

  # Description: EC2 Instance Profile Name
  instance_profile_name = "nexus-profile"

  # Description: AWS Key Pair to use for instances in the cluster
  key_name = "jeff-vpc"

  # Description: Role Name
  role_name = "nexus-role"

  # Description: Role Policy Name
  role_policy_name = "EC2DomainJoin"

  # -----------------------------------------
  # START OF NEW VARIABLES FOR ECS SERVICE/TASKSi

  # Name of container within load balancer
  container_name = "nexus-container"

  # AMI ECS image values/filter
  ami_filter = "*-amazon-ecs-optimized"

  # ECS task definition name
  ecs_task_def_name = "nexus_task"

  # ECS task definition's docker image
  #ecs_task_def_docker_image = "647770347641.dkr.ecr.us-east-2.amazonaws.com/nexus"
  ecs_task_def_docker_image = "647770347641.dkr.ecr.us-east-2.amazonaws.com/jeff-repo"

  # ECS task definition's cpu units (max 1024)
  ecs_task_def_cpu_units = 256

  # ECS task definition's memory units (max 1024)
  ecs_task_def_memory_units = 2048

  # ECS task definition's memory reservation
  ecs_task_def_memory_reservation = 2048

  # ECS service name
  ecs_service_name = "nexus_service"

  ecs_service_tasks_desired_count = 1

  efs_name = "nexus-efs"
  efs_token = "mexus"
  efs_mode = "generalPurpose"
  efs_encrypted = false
}
