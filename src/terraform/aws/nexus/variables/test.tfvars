# insert the 10 required variables here

# region
region = "us-east-2"

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

# Launch control public ip address (true/false)
launch_control_public_ip = "true"

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
