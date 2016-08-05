# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}


resource "aws_autoscaling_group" "jenkins-asg" {
  #availability_zones = ["${split(",", var.availability_zones)}"]
  name = "jenkins-asg"
  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  desired_capacity = "${var.asg_desired}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.jenkins-lc.name}"
  vpc_zone_identifier = ["${split(",", var.availability_zones)}"]
  tag {
    key = "Name"
    value = "jenkins-host"
    propagate_at_launch = "true"
  }
}


data "template_file" "init" {
    template = "${file("init.tpl")}"
    vars {
        efs_id = "${aws_efs_file_system.myefs.id}"
    }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Setup hello world script to be called by the cloud-config
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.init.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "baz"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "ffbaz"
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

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "jenkins_sg" {
  name = "jenkins_sg"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["192.168.0.0/24"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
