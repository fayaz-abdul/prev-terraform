variable "environment" {
    type = string
}


variable "cidr_block" {
    type = string
}

variable "subnet_cidr_block_public" {
    type = string
}

variable "subnet_cidr_block_private" {
    type = string
}
variable "project" {
    type = string
}

variable "ami" {
    type = string
}

variable subnets{}
variable private_subnet{}
variable public_subnet{}
variable sg_private{}
variable sg_public{}
#variable aws_instance{}