variable "aws_region" {
  description = "The AWS region to create things in."
}

variable "aws_amis" {
  type = "map"
  default = {
    "us-east-1" = ""
    "us-west-2" = ""
  }
}

variable "vpc_cidr_block" {
  description = "VPC IP Range"
}

variable "availability_zones" {
  description = "List of availability zones, use AWS CLI to find yours "
}

variable "key_name" {
  description = "Name of AWS key pair"
}

variable "instance_type" {
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
}

variable "server_ip" {
  description = "static ip for server"
}

variable "my_ip" {
  description = "my static ip"
}
