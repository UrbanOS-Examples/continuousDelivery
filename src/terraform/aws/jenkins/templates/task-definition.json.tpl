[
  {
    "name": "${name}",
    "image": "${image}",
    "memory": 1024,
    "essential": true,
    "command": ${command},
    "environment" : [{ "name" : "ELB_NAME", "value" : "${elb_name}" }],
    "portMappings": [
      {
        "containerPort": ${port},
        "hostPort": ${port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}"
      }
    }
  }
]
