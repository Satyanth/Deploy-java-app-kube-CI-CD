provider "aws" {
  region = "us-east-1"
}



resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev_vpc"
  }
}

resource "aws_subnet" "vpc_subnet_01" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev_public_subnet_01"
  }

}

resource "aws_subnet" "vpc_subnet_02" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev_public_subnet_02"
  }

}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "dev_igw"
  }
}

resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }
}

resource "aws_route_table_association" "dev_route_assoc_subnet_01" {
  subnet_id      = aws_subnet.vpc_subnet_01.id
  route_table_id = aws_route_table.dev_route_table.id

}

resource "aws_route_table_association" "dev_route_assoc_subnet_02" {
  subnet_id      = aws_subnet.vpc_subnet_02.id
  route_table_id = aws_route_table.dev_route_table.id

}

resource "aws_security_group" "dev_sg" {
  name   = "dev-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

}



resource "aws_instance" "ec2_inst" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name      = "dev_proj"


  subnet_id              = aws_subnet.vpc_subnet_01.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  for_each               = toset(["jenkins-master", "build-slave", "ansible"])
  tags = {
    Name = "${each.key}"
  }

}
