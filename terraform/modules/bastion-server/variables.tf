variable "region" {
  description = "The region to launch the instances"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_id" {
  description = "Variable for vpc ID identifier"
  type        = string
}

variable "subnet_id" {
  description = "Variable for subnet ID"
  type        = string
}

variable "key_name" {
  description = "Key name for SSHing into EC2"
  type        = string
  default     = "kaypair_name"
}

variable "amis" {
  description = "Base AMI to launch the instances"
  default = {
    ap-southeast-1 = "ami-02ee763250491e04a"
  }
}