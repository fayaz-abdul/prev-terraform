resource "aws_vpc" "vpc_cloud" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.environment}-${var.project}-vpc-cloud"
    Environment = var.environment
  }
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc_cloud.id
  cidr_block = var.subnet_cidr_block_public
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.environment}-${var.project}-subnet-public"
    Environment = var.environment
  }
}

resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.vpc_cloud.id
  cidr_block = var.subnet_cidr_block_private
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.environment}-${var.project}-subnet-private"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_cloud.id

  tags = {
    Name = "${var.environment}-${var.project}-igw"
    "Environment" = var.environment
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id =  aws_vpc.vpc_cloud.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
    route {
    cidr_block = var.peering_region_cidr
    vpc_peering_connection_id = var.peer_con_id
  }
  tags = {
    Name = "${var.environment}-${var.project}-Public-RouteTable"
    "Environment" = var.environment
	}
}

resource "aws_route_table_association" "route_table_association_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.route_table_public.id
	
}

resource "aws_eip" "Nat-Gateway-EIP" {
  depends_on = [
	aws_route_table_association.route_table_association_public
  ]
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP
  ]

  allocation_id = aws_eip.Nat-Gateway-EIP.id

  subnet_id = aws_subnet.subnet_private.id
  tags = {
    Name = "Nat-Gateway_Project"
  }
}

resource "aws_route_table" "route_table_private" {
  depends_on = [
    aws_nat_gateway.nat_gateway
  ]

  vpc_id =  aws_vpc.vpc_cloud.id

    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
    route {
    cidr_block = var.peering_region_cidr
    vpc_peering_connection_id = var.peer_con_id
  }
  tags = {
    Name = "${var.environment}-${var.project}-Private-RouteTable"
    "Environment" = var.environment
        }
}

resource "aws_route_table_association" "route_table_association_private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.route_table_private.id
}


resource "aws_security_group" "sg_public" {
  name = "vpc_test_public"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc_cloud.id

  tags = {
    Name = "Public SG"
  }
}

# Define the security group for private subnet
resource "aws_security_group" "sg_private"{
  name = "sg_test_private"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.sg_public.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }


  vpc_id = aws_vpc.vpc_cloud.id

  tags = {
    Name = "Private SG"
  }
}


output "cloud_vpc_id" {
    value = aws_vpc.vpc_cloud.id
}

output "cloud_vpc_id_cidr" {
    value = aws_vpc.vpc_cloud.cidr_block
}

output "vpc_subnet_ids" {
    value = [aws_subnet.subnet_public.id,aws_subnet.subnet_private.id]
}

output "private_subnet" {
  value = aws_subnet.subnet_private.id
}
output "public_subnet" {
  value = aws_subnet.subnet_public.id
}

output "sg_public" {
  value = aws_security_group.sg_public.id
}

output "sg_private" {
  value = aws_security_group.sg_private.id
}
