
## Build a jenkins ci  on nomad docker scheduler

Non-OOTB solution , help you to understand how to build a tiny cluster stack over the cloud. Many examples demostrate the terraform , cloudinit and ansible usage.


### Stack 
Alpine Dockerized Jeknins 2.7 + Jenkinsfile plugin

Jenkins slave as docker and Nomad as docker scheduler

Terraform provision AWS ASG + EFS

### Architecture
```
1 VPC
1 Security group
1 EFS with multiple target across zone 
1 EC2 instance for jenkins server / nomad server
1 Autoscale group for jenkins slaves /nomad client
1 AMI ami-116d857a, debian jessie
Jenkins 2.7
Nomad 0.4.0 
```

### Instructions

Requirement
```
Clone this repo 
Install ansible & nomad & terraform locally 
Create aws access key and config aws env variable , please terraform aws config
```


Created aws resource , installed/configured  nomad and docker through userdata

Edit reqiured variable in dev.tfvars file
```
cd /terraform
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

Start jenkins server from docker

```
cd /manage
./jenkins.sh <server public IP> ~/.ssh/<your ssh key>
```

Access jenkins server , disable security

`http://<server public IP>:8080`
 
Start slaves by nomad job definition file
```
export NOMAD_ADDR=http://<your server public IP>:4646
cd /manage
nomad node-status
nomad run jenkins-slave.nomad
nomad status ciworker
```

you should able to see new machine from Build Executor Status of jenkins

To increase/decrease slave numbers , just edit count number in jenkins-slave.nomad then rerun the job `nomad run jenkins-slave.nomad`


#### Why not putting jenkins server into nomad cluster
1. Nomad not support volume map for its docker driver , in this example jenkins need volume map to efs drive.
2. Jenkins is not lightweight , 200MB+ even with alpine.
3. With EFS and docker , jenkins server recover can be done within a few seconds . my example using ansible to do that . There are also other solution might be consider , like call plain shell via raw driver of Nomad .   
4. If do so we might need add consul to located the service . 

### License
MIT.
