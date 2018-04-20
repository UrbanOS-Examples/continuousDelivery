provider "aws" {
    region = "us-east-2"
}

module "ecs-scalable-cluster" "nexus-cluster" {
  source = "../../../terraform-aws-ecs-scalable-cluster"
#  source  = "anugnes/ecs-scalable-cluster/aws"
  version = "1.1.4"

  # insert the 10 required variables here

  # Description: This is the ID of the VPC you want to use
  vpc_id = "vpc-5d006f35"

  # Description: List of subnet IDs to use when spinning up your cluster
  subnet_id = "subnet-7edebb16"
#  subnet_id = "subnet-jeff"

  # Description: EC2 Instance Type
  type = "t2.micro"

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
  # START OF NEW VARIABLES FOR ECS SERVICE/TASKS JUNK

  # Name of container within load balancer
  container_name = "nexus-container"
}
