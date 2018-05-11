resource "aws_ecs_service" "mongo" {
  name            = "mongodb"
  cluster         = "${aws_ecs_cluster.foo.id}"
  task_definition = "${aws_ecs_task_definition.mongo.arn}"
  desired_count   = 3
  iam_role        = "${aws_iam_role.foo.arn}"
  depends_on      = ["aws_iam_role_policy.foo"]

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    elb_name       = "${aws_elb.foo.name}"
    container_name = "mongo"
    container_port = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
