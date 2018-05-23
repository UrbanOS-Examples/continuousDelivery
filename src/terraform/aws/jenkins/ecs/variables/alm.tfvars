deployment_identifier = "alm"

#Cluster variables
cluster_instance_ssh_public_key_path = "~/.ssh/id_rsa.pub"
cluster_instance_type = "t2.small"
cluster_instance_user_data_template = "templates/instance-user-data.tpl"
cluster_instance_iam_policy_contents = "templates/instance-policy.json"

cluster_minimum_size = 1
cluster_maximum_size = 3
cluster_desired_capacity = 2
allowed_cidrs = ["0.0.0.0/0"]

#Load Balancer variables
service_port = 8080
domain_name = "deliveryPipeline.smartcolumbusos.com"
public_zone_id = ""
private_zone_id = ""
allow_lb_cidrs = ["0.0.0.0/0"]
include_public_dns_record = "no"
include_private_dns_record = "no"
expose_to_public_internet = "yes"

#Service variables
service_name = "jenkins-master"
service_image = "mihailrc/jenkins"
service_task_container_definitions="templates/task-definition.json.tpl"
attach_to_load_balancer = "yes"
memory = 1024
directory_name = "jenkins_home"
