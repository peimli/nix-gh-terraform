
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.az
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.az

}
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}
resource "aws_route_table_association" "public_subnet_rt_assocation" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
}
resource "aws_route_table_association" "private_subnet_rt_assocation" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main_vpc.id
  
 ingress=[                
   {
description      = ""
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     security_groups  = []
     self             = false
     cidr_blocks      = [ "0.0.0.0/0", ]
     from_port        = 80
     protocol         = "tcp"
     to_port          = 80
  }]
  
  egress = [
{
description      = ""
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     security_groups  = []
     self             = false
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0",]
}
]
}
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main_vpc.id
 ingress                = [
   { 
description      = ""
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     security_groups  = []
     self             = false
     cidr_blocks      = [ var.vpc_cidr, ]
     from_port        = 22
     protocol         = "tcp"
     to_port          = 22
  }
  ]
  egress = [
{

description      = ""
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     security_groups  = []
     self             = false
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0",]
}
]
}
resource "aws_eip" "nat_eip" {
}
