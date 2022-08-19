# Global variables #
variable "region" {
  description = "us-east-1"
}

variable "environment" {
  description = "The Deployment environment"
}

# Networking module vars #
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
}

# app-asg module vars #
variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default     = "/path_to_keyfile/keypair_name.pem"
}

variable "key_name" {
  description = "Key name for SSHing into EC2"
  default     = "kaypair_name"
}

variable "amis" {
  description = "Base AMI to launch the instances"
  default = {
    ap-south-1 = "ami-8da8d2e2"
  }
}

variable "asg_min_size" {
  description = "Variable for asg mininum size"
  type        = string
  default     = "2"
}

variable "asg_max_size" {
  description = "Variable for asg maximum size"
  type        = string
  default     = "3"
}