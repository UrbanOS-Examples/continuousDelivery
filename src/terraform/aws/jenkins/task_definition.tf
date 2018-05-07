data "template_file" "task_definition" {
  template = "${file("${path.module}/templates/task-definition.json.tpl")}"

  vars {
    name = "${var.service_name}"
    image = "${var.service_image}"
    command = "${jsonencode(var.service_command)}"
    port = "8080"
    region = "${var.region}"
    log_group = "${module.jenkins_service.log_group}"
    elb_name = "${module.ecs_load_balancer.name}"
  }
}
