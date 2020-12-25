

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
#output "aws_instance" {
#resource "aws_instance" "Jenkins" {
#  value = aws_instance.jenkins.id
#}