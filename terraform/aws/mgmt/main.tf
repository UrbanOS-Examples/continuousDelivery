provider "aws" {
  region     = "us-east-2"
}

resource "aws_vpc" "scos_cicd_vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "scos_cicd_vpc"
  }
}

//resource "aws_route53_zone" "scos-cicd" {
//  name = "no-clue-what-this-should-be"
//}

data "aws_route_table" "default-local-vpc-rtb" {
  vpc_id = "${aws_vpc.scos_cicd_vpc.id}"
}

data "aws_availability_zones" "available" {}

module "jenkins" {
  source = "../modules/jenkins-bg-tf"

  project     = "scos"
  environment = "mgmt"
  component   = "jenkins"

  vpc_id             = "${aws_vpc.scos_cicd_vpc.id}"
  availability_zones = "${data.aws_availability_zones.available.names}"
//  hosted_zone_id     = "${aws_route53_zone.scos-cicd.zone_id}"
  domain_name        = "jenkins.cicd.scos"

  private_route_table_ids = ["${data.aws_route_table.default-local-vpc-rtb.id}"]

  #launch configuration for the master
  lc_instance_type = "t2.micro"
  lc_ami_id        = "ami-bb8eaede"
  lc_key_name      = "my-lab-key-name"

  ebs_volume_size = 10

  jenkins_blue_version       = "2.73.1-1.1"
  jenkins_green_version      = "latest"
  jenkins_blue_subnet_cidrs  = ["10.0.0.0/28"]
  jenkins_green_subnet_cidrs = ["10.0.0.16/28"]

  elb_subnets_cidrs = [
    "10.0.0.32/28",
    "10.0.0.48/28",
    "10.0.0.64/28",
  ]
}
