resource "aws_vpc" "ec_cube_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  tags = {
    Name = "ec-cube-vpc"
  }
}

resource "aws_internet_gateway" "ec_cube_igw" {
  vpc_id = aws_vpc.ec_cube_vpc.id
  tags = {
    Name = "ec-cube-igw"
  }
}

resource "aws_route_table" "ec_cube_public_rtb" {
  vpc_id = aws_vpc.ec_cube_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec_cube_igw.id
  }
  tags = {
    Name = "ec-cube-public-rtb"
  }
}

resource "aws_subnet" "ec_cube_public_subnet" {
  vpc_id            = aws_vpc.ec_cube_vpc.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "ec-cube-public-subnet"
  }
}

resource "aws_route_table_association" "ec_cube_rtb_to_public_subnet" {
  subnet_id      = aws_subnet.ec_cube_public_subnet.id
  route_table_id = aws_route_table.ec_cube_public_rtb.id
}