[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "memoryReservation": ${memoryReservation},
    "essential": true,
    "portMappings": [
        {
            "containerPort": ${port},
            "hostPort": ${port}
        }
    ],
    "mountPoints": [
          {
            "sourceVolume": "${directory_name}",
            "containerPath": "/${directory_name}"
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
