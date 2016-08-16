job "ciworker" {
	region = "us-east-1"
	datacenters = ["dc1"]
	type = "service"
	update {
		stagger = "10s"
		max_parallel = 1
	}
	group "ci" {
		count = 2
		restart {
			interval = "5m"
			attempts = 10
			delay = "25s"
			mode = "delay"
		}
		task "slave" {
			driver = "docker"
			config {
				image = "yikaus/jenkinsslave"
			}
			env {
				JENKINS_HOST = "172.31.0.10:8080"
			}
			resources {
				cpu = 1024 # 1024 Mhz
				memory = 200 # 200MB
				network {
					mbits = 10
				}
			}
		}
	}
}