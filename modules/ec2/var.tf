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

variable "aws_vpc" {
    type = string
}

variable subnets{}