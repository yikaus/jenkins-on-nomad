# Specify the provider and access details

resource "aws_autoscaling_group" "jenkins-asg" {
  #availability_zones = ["${split(",", var.availability_zones)}"]
  depends_on = ["aws_instance.server"]
  name = "jenkins-asg"
  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  desired_capacity = "${var.asg_desired}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.jenkins-lc.name}"
  vpc_zone_identifier = ["${aws_subnet.public-subnet.*.id}"]
  tag {
    key = "Name"
    value = "jenkins-host"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "jenkins-lc" {
  name = "jenkins-lc"
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  # Security group
  security_groups = ["${aws_security_group.jenkins_sg.id}"]
  user_data = "${data.template_cloudinit_config.config.rendered}"
  key_name = "${var.key_name}"
}

