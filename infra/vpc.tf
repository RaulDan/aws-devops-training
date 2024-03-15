locals {
  azs = ["us-east-1a", "us-east-1b"]
}

resource "aws_vpc" "online-shop-vpc" {
  cidr_block = "10.0.0.0/16"
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "VPC for online shop app"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.online-shop-vpc.id
  tags = {
    Name = "Online Shop VPC - Internet Gateway"
  }
}

#Public subnets
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.online-shop-vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(local.azs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Public subnet ${count.index}: ${element(local.azs, count.index)}"
  }
}

#Private subnets
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.online-shop-vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(local.azs, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "Private subnet ${count.index}: ${element(local.azs, count.index)}"
  }
}

#Route table
resource "aws_route_table" "online_shop_route_table" {
  vpc_id = aws_vpc.online-shop-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "online_shop_public_subnets_association" {
  count          = length(var.public_subnets_cidr)
  route_table_id = aws_route_table.online_shop_route_table.id
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
}

resource "aws_security_group" "online_shop_backend" {
  vpc_id = aws_vpc.online-shop-vpc.id
  name   = "online_shop_backend"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myIp.response_body)}/32"]
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

resource "aws_security_group" "rds_security_group" {
  vpc_id = aws_vpc.online-shop-vpc.id
  name   = "online_shop_database"
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.online_shop_backend.id]
  }
}

resource "aws_security_group" "redis_security_group" {
  vpc_id = aws_vpc.online-shop-vpc.id
  name   = "redis_security_group"
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.online_shop_backend.id]
  }
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.online-shop-vpc.id
  name   = "Load Balancer Security Group"
  ingress {
    from_port   = 80
    to_port     = 80
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
