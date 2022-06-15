
resource "aws_vpc" "vpc_tf" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_tf"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "public subnet"
  }
}
/*
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_tf.id
  cidr_block = var.private_subnet_cidr
  #availability_zone = ""
  tags = {
    Name = "private subnet"
  }
} */

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "vpc gateway"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
  tags = {
    Name = "Public Subnet Route Table"
  }
}
# Assign the route table to the public subnet
resource "aws_route_table_association" "public-rt" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_tcp"
  description = "Allow SSH and TCP inbound traffic"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TCP from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc_tf.id
  tags = {
    Name = "allow_ssh_tcp"
  }
}

#difining security group for private subnet
/*resource "aws_security_group" "allow_ssh_private" {
  name        = "allow_ssh_tcp"
  description = "Allow SSH and TCP inbound traffic"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  ingress {
    description = "TCP from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id      = aws_vpc.vpc_tf.id
  tags = {
    Name = "allow_ssh_tcp_private_subnet"
  }
} */