
provider "aws" {
  region = "${var.aws_region}"
}

#VPC
resource "aws_vpc" "myvpc" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
        Name = "myvpc"
	}
}

##Subnet on each zone
resource "aws_subnet" "public-subnet" {
    vpc_id            = "${aws_vpc.myvpc.id}"
    count             = "${length(split(",", var.availability_zones))}"
    cidr_block        = "${cidrsubnet(var.vpc_cidr_block, 8, count.index)}"
    availability_zone = "${element(split(",", var.availability_zones), count.index)}"
    map_public_ip_on_launch = true

    tags {
        "Name" = "public-${element(split(",", var.availability_zones), count.index)}-sn"
    }
}


#Gateway
resource "aws_internet_gateway" "my_igw" {
    vpc_id = "${aws_vpc.myvpc.id}"
}

#RouteTable
resource "aws_route_table" "ext_route" {
    vpc_id = "${aws_vpc.myvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.my_igw.id}"
    }
    tags {
        Name = "ext_route"
	  }  
}

resource "aws_route_table_association" "public_ra" {
    count = "${length(split(",", var.availability_zones))}"
    subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index)}"
    route_table_id = "${aws_route_table.ext_route.id}"
}

resource "aws_security_group" "jenkins_sg" {
  name = "jenkins_sg"
  description = "Used in the terraform"
  vpc_id = "${aws_vpc.myvpc.id}"
  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }

  # HTTP access from anywhere
  ingress {
    from_port = 2000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }
  
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}