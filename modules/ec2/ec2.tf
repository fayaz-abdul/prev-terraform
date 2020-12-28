

resource "aws_ebs_volume" "nfs" {
  availability_zone = "eu-west-3b"
  size              = 8

  tags = {
    Name = "nfs volume"
  }
}

resource "aws_ebs_volume" "exports" {
  availability_zone = "eu-west-3b"
  size              = 8

  tags = {
    Name = "exports volume"
  }
}

resource "aws_instance" "controller" {
  ami = var.ami
  instance_type = "t2.micro"
  subnet_id = var.private_subnet

 # key_name = "MyKeyFinal"

  vpc_security_group_ids = [var.sg_private]

  tags = {
   Name = "Controller server"
  }
}
resource "aws_instance" "Jenkins" {
  ami = var.ami
  instance_type = "t2.micro"
  subnet_id = var.public_subnet

 # key_name = "MyKeyFinal"

  vpc_security_group_ids = [var.sg_public]

  tags = {
   Name = "Jenkins server"
  }
}

resource "aws_volume_attachment" "ebs_nfs" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.nfs.id
  instance_id = aws_instance.controller.id
}

resource "aws_volume_attachment" "ebs_exports" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.exports.id
  instance_id = aws_instance.controller.id
}
# peering connection

data "aws_caller_identity" "current" {}

resource "aws_vpc_peering_connection" "con" {
    vpc_id        = var.cloud_vpc_id
    peer_owner_id = data.aws_caller_identity.current.account_id
    peer_vpc_id   = "vpc-026eee10a17cc7d8e"
    peer_region = "eu-west-1"
  
}
provider "aws" {
  alias = "new"
  region = "eu-west-1"
  
}
resource "aws_vpc_peering_connection_accepter" "con_accept" {
  provider = aws.new
  vpc_peering_connection_id = aws_vpc_peering_connection.con.id
  auto_accept = true
    tags = {
    Side = "Paris-Ireland-peering"
  }
 }

output "peer_con_id" {
    value = aws_vpc_peering_connection.con.id
}
