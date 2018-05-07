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

  component = "${var.component}"
  deployment_identifier = "${var.deployment_identifier}"

  cluster_name = "${var.cluster_name}"
  cluster_instance_ssh_public_key_path =  "${var.cluster_instance_ssh_public_key_path}"
  cluster_instance_type =  "${var.cluster_instance_type}"
  cluster_instance_user_data_template =  "${file(var.cluster_instance_user_data_template)}"
  cluster_instance_iam_policy_contents =  "${file(var.cluster_instance_iam_policy_contents)}"

  cluster_minimum_size =  "${var.cluster_minimum_size}"
  cluster_maximum_size =  "${var.cluster_maximum_size}"
  cluster_desired_capacity =  "${var.cluster_desired_capacity}"
  allowed_cidrs =  "${var.allowed_cidrs}"
}

module "ecs_load_balancer" {
  #infrablocks load balancer uses HTTPS which in turn requires a certificate.
  #to issue these we need to set up a certificate manager. To avaoid nother
  #wild goose chase AWS style I simply compied the module and changed the protocol to HTTP

  source = "../modules/elb"
  version = "0.1.10"

  region = "${var.region}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet_ids = "${data.terraform_remote_state.vpc.public_subnets}"

  component =  "${var.component}"
  deployment_identifier = "${var.deployment_identifier}"

  service_name = "${var.service_name}"
  service_port = "8080"
  service_certificate_arn = ""

  domain_name = "deliveryPipeline.smartcolumbusos.com"
  public_zone_id = "Z2TQLOWLDABB3W"
  private_zone_id = "Z3KXSBDSLMD8L4"

  health_check_target = "HTTP:8080/login"

  allow_cidrs = [
    "0.0.0.0/0"
  ]

  include_public_dns_record = "yes"
  include_private_dns_record = "no"

  expose_to_public_internet = "yes"
}

module "jenkins_service" {
  source = "infrablocks/ecs-service/aws"
  version = "0.1.10"

  region = "${var.region}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  component = "${var.component}"
  deployment_identifier = "${var.deployment_identifier}"

  service_name = "${var.service_name}"
  service_image = "${var.service_image}"
  service_port = "8080"
  service_task_container_definitions="${data.template_file.task_definition.rendered}"

  service_desired_count = "1"
  service_deployment_maximum_percent = "100"
  service_deployment_minimum_healthy_percent = "50"

  attach_to_load_balancer = "${var.attach_to_load_balancer}"
  service_elb_name = "${module.ecs_load_balancer.name}"

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
