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

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/22"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public AZ2"
  }
}

resource "aws_subnet" "public_az3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.8.0/22"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public AZ3"
  }
}

resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/22"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "private AZ1"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/22"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "private AZ2"
  }
}

resource "aws_subnet" "private_az3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.24.0/22"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "private AZ3"
  }
}

resource "aws_subnet" "data_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/22"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "data AZ1"
  }
}

resource "aws_subnet" "data_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.36.0/22"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "data AZ2"
  }
}

resource "aws_subnet" "data_az3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.40.0/22"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "data AZ3"
  }
}


resource "aws_db_subnet_group" "data_subnet_group" {
  name       = "data_subnet_group"
  subnet_ids = [aws_subnet.data_az1.id, aws_subnet.data_az2.id, aws_subnet.data_az3.id]
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

resource "aws_lb_target_group" "web" {
  name     = "tech-challenge-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "web_attachement" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_lb" "public_lb" {
  name               = "Servian-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http_ssh.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}