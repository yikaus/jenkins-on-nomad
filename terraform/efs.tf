

resource "aws_efs_file_system" "myefs" {
  tags {
    Name = "MyEFS"
  }
}

resource "aws_efs_mount_target" "myefs_target" {
  count = "${length(split(",", var.availability_zones))}"
  file_system_id = "${aws_efs_file_system.myefs.id}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  security_groups = ["${aws_security_group.jenkins_sg.id}"]
}