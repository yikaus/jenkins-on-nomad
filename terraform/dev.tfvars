aws_region = "us-east-1"
key_name = "testkey"
availability_zones = "us-east-1b,us-east-1c"
vpc_cidr_block = "172.31.0.0/16"
aws_amis = {
  "us-east-1" = "ami-116d857a"
}
instance_type = "t2.micro"
asg_min = "1"
asg_max = "2"
asg_desired = "1"
server_ip = "172.31.0.2"
#get my ip : dig +short myip.opendns.com @resolver1.opendns.com
my_ip = "118.209.165.204/32"