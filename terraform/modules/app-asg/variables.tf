variable "region" {
  description = "The region to launch the instances"
  type        = string
  default     = "eu-west-1"
}

variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  type        = string
  default     = "/path_to_keyfile/keypair_name.pem"
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

variable "vpc_zone_identifier" {
  description = "Variable for vpc availability zone identifier"
  type        = list(any)
}

variable "vpc_id" {
  description = "Variable for vpc ID identifier"
  type        = string
}

variable "asg_min_size" {
  description = "Variable for asg mininum size"
  type        = string
  default = "2"
}

variable "asg_max_size" {
  description = "Variable for asg maximum size"
  type        = string
  default = "3"
}