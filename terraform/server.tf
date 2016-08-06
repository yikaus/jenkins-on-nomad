
data "template_file" "server" {
    template = "${file("server.tpl")}"
    vars {
        region = "${var.aws_region}"
    }
}

data "template_cloudinit_config" "serverconfig" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.init.rendered}"
  }
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.server.rendered}"
  }
}

resource "aws_instance" "server" {
  instance_type = "${var.instance_type}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  private_ip = "${var.server_ip}"
  subnet_id = "${aws_subnet.public-subnet.0.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_sg.id}"]
  user_data = "${data.template_cloudinit_config.serverconfig.rendered}"
  tags {
    Name = "server"
  }
}