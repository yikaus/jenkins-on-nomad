data "template_file" "init" {
    template = "${file("init.tpl")}"
    vars {
        efs_id = "${aws_efs_file_system.myefs.id}"
    }
}

data "template_file" "client" {
    template = "${file("client.tpl")}"
    vars {
        region = "${var.aws_region}"
        server_ip = "${var.server_ip}"
    }
}


data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.init.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.client.rendered}"
  }

}

data "template_file" "server" {
    template = "${file("server.tpl")}"
    vars {
        region = "${var.aws_region}"
    }
}

data "template_cloudinit_config" "serverconfig" {
  gzip          = true
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.init.rendered}"
  }
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.server.rendered}"
  }
}
