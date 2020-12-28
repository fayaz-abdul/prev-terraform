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
variable "peering_region_cidr" {}

variable subnets{}
variable "peer_con_id" {
    type = string 
  
}
