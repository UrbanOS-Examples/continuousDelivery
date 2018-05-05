provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
   bucket = "scos-terraform-state"
   key    = "jenkins"
   region = "us-east-2"
   dynamodb_table="terraform_lock"
   encrypt = "true"
   role_arn = "arn:aws:iam::784801362222:role/UpdateTerraform"
 }
}

#refer to existing VPC
data "terraform_remote_state" "vpc" {
 backend     = "s3"
 workspace = "${terraform.workspace}"

 config {
   bucket = "scos-terraform-state"
   key    = "vpc"
   region = "us-east-2"
   role_arn = "arn:aws:iam::784801362222:role/UpdateTerraform"
 }
}

module "jenkins_cluster" {
  source = "infrablocks/ecs-cluster/aws"
  version = "0.2.5"

  region = "${var.region}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet_ids = "${join(",",data.terraform_remote_state.vpc.public_subnets)}"

  component = "delivery-pipeline"
  deployment_identifier = "test"

  cluster_name = "jenkins-cluster"
  cluster_instance_ssh_public_key_path = "~/.ssh/id_rsa.pub"
  cluster_instance_type = "t2.small"
  cluster_instance_user_data_template = "${file("templates/instance-user-data.tpl")}"
  cluster_instance_iam_policy_contents = "${file("templates/instance-policy.json")}"

  cluster_minimum_size = 1
  cluster_maximum_size = 4
  cluster_desired_capacity = 2
}

module "jenkins_service" {
  source = "infrablocks/ecs-service/aws"
  version = "0.1.10"

  region = "${var.region}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  component = "delivery-pipeline"
  deployment_identifier = "test"

  service_name = "jenkins-master"
  service_image = "mihailrc/jenkins"
  service_port = "8080"
  service_task_container_definitions="${file("templates/task-definition.json")}"

  service_desired_count = "1"
  service_deployment_maximum_percent = "100"
  service_deployment_minimum_healthy_percent = "50"

  attach_to_load_balancer = "no"
#  service_elb_name = "elb-service-web-app"

  service_volumes = [
    {
      name = "data"
    }
  ]

  ecs_cluster_id = "${module.jenkins_cluster.cluster_id}"
  ecs_cluster_service_role_arn = "${module.jenkins_cluster.service_role_arn}"
}

#todo: EFS, MountTarget, userData, scaling policy
# Load Balancer
