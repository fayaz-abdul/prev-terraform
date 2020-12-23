
resource "aws_instance" "controller" {
  ami = var.ami
  instance_type = "t2.micro"
  subnet_id = module.subnet_public.id

 # key_name = "MyKeyFinal"

#  vpc_security_group_ids = aws_security_group.sg_private.id

  tags = {
   Name = "Controller server"
  }
}
