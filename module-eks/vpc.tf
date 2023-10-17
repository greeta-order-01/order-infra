resource "aws_vpc" "sandbox" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = {
    Name   = var.vpc_name
    Author = var.author
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"    
  }

}

// 2 Public Subnets
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.sandbox.id
  cidr_block              = "10.1.${count.index * 2 + 1}.0/24"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  count = var.public_subnets_count

  tags = {
    Name   = "public_10.1.${count.index * 2 + 1}.0_${element(data.aws_availability_zones.available.names, count.index)}"
    Author = var.author
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sandbox.id

  tags = {
    Name   = "igw_${var.vpc_name}"
    Author = var.author
  }
}

// Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sandbox.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name   = "public_rt_${var.vpc_name}"
    Author = var.author
  }
}

// Associate public subnets to public route table
resource "aws_route_table_association" "public" {
  count          = var.public_subnets_count
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}