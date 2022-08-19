resource "random_id" "random_id_prefix" {
  byte_length = 2
}

# Variables used across all modules #
locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

# Variables used in networking module #
module "networking" {
  source = "./modules/networking"

  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.production_availability_zones
}

# Variables used in bastion server #
module "bastion-server" {
  source = "./modules/bastion-server"

  region    = var.region
  vpc_id    = module.networking.vpc_id
  key_name  = var.key_name
  subnet_id = module.networking.public_subnet_id
}

# Variables used in app-asg module #
module "app-asg" {
  source = "./modules/app-asg"

  region              = var.region
  public_key_path     = var.public_key_path
  key_name            = var.key_name
  vpc_zone_identifier = module.networking.public_subnets_id
  vpc_id              = module.networking.vpc_id
}
