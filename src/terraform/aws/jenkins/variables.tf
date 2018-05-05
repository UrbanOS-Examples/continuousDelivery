variable "region" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "component" {
  description = "The component this cluster will contain"
  default = "delivery-pipeline"
}

variable "deployment_identifier" {
  description = "An identifier for this instantiation"
}

#cluster variables
variable "cluster_name" {
  description = "AWS The name of the cluster to create"
  default     = "jenkins-cluster"
}

variable "cluster_instance_ssh_public_key_path" {
  description = "AWS The path to the public key to use for the container instances"
}

variable "cluster_instance_type" {
  description = "The instance type of the container instances"
  default     = "t2.medium"
}

variable "cluster_instance_user_data_template" {
  description = "The contents of a template for container instance user data"
  default     = ""
}

variable "cluster_instance_iam_policy_contents" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "cluster_minimum_size" {
  description = "The minimum size of the ECS cluster"
  default     = 1
}

variable "cluster_maximum_size" {
  description = "The maximum size of the ECS cluster"
  default     = 10
}

variable "cluster_desired_capacity" {
  description = "The desired capacity of the ECS cluster"
  default     = 3
}

variable "allowed_cidrs" {
  description = "The CIDRs allowed access to containers"
  type = "list"
  default     = ["10.0.0.0/8"]
}

#service variables
variable "service_name" {
  description = "The name of the service being created"
}

variable "service_image" {
  description = "The docker image (including version) to deploy"
}

variable "service_task_container_definitions" {
  description = "A template for the container definitions in the task"
  default     = ""
}

variable "attach_to_load_balancer" {
  description = "Whether or not this service should attach to a load balancer"
  default     = "yes"
}

variable "service_elb_name" {
  description = "The name of the ELB to configure to point at the service containers"
  default     = ""
}
