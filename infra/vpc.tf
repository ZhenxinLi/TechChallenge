// Create a VPC with CIDR block 10.0.0.0/16. 
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Servian Tech Challenge"
  }
}

// subnets break our VPC into smaller networks to provide greater control of where services are hosted and what can access them.
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/22"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public AZ1"
  }
}

resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/22"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private AZ1"
  }
}

resource "aws_subnet" "data_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/22"
  availability_zone = "us-east-1a"

  tags = {
    Name = "data AZ1"
  }
}


// • Add an internet gateway to the VPC. 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Servian Tech Challenge igw"
  }
}

// • Add a default route table to the VPC which routes 0.0.0.0/0 to the internet gateway.  
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Servian route table"
  }
}