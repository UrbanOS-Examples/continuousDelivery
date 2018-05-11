[
  {
    "name": "${name}",
    "image": "${image}",
    "memory": ${memory},
    "essential": true,
    "command": ${command},
    "environment" : [{ "name" : "ELB_NAME", "value" : "${elb_name}" }],
    "portMappings": [
      {
        "containerPort": ${port},
        "hostPort": ${port}
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${directory_name}",
        "containerPath": "/var/${directory_name}"
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
