# AWS #
region      = "ap-southeast-1"
environment = "interview-govtech-assignment-env"

# module networking #
vpc_cidr             = "20.0.0.0/16"
public_subnets_cidr  = ["20.0.2.0/24", "20.0.3.0/24"]
private_subnets_cidr = ["20.0.20.0/24", "20.0.21.0/24","20.0.22.0/24","20.0.23.0/24"]

# module app-asg #
public_key_path = "../gt_kp1.pem"
key_name        = "gt_kp1"
amis            = "ami-02ee763250491e04a"
min_size        = "2"
max_size        = "3"