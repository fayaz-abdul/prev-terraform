
provider "aws" {
  region = "eu-west-3"
}

module "iam" {
  source = "../modules/iam"
  environment = var.environment
  project = var.project
  }

module "vpc" {
  source = "../modules/vpc"
  project = var.project
  environment = var.environment
  cidr_block = var.cidr_block
  subnet_cidr_block_public = var.subnet_cidr_block_public
  subnet_cidr_block_private = var.subnet_cidr_block_private
  subnets = module.vpc.vpc_subnet_ids
}

module "ec2" {
  project = var.project
  environment = var.environment
  source = "../modules/ec2"
  cidr_block = var.cidr_block
  subnet_cidr_block_public = var.subnet_cidr_block_public
  subnet_cidr_block_private = var.subnet_cidr_block_private
  subnets = module.vpc.vpc_subnet_ids
  ami = var.ami
#  vpc_id = module.vpc.vpc_id
  private_subnet = module.vpc.private_subnet
  public_subnet = module.vpc.public_subnet
  sg_public = module.vpc.sg_public
  sg_private = module.vpc.sg_private
  cloud_vpc_id = module.vpc.cloud_vpc_id
 # aws_instance = module.ec2.aws_instance
}

