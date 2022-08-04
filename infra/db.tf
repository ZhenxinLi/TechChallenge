// Creating the security groups for db and web to use on appropriate ports
resource "aws_security_group" "allow_http_ssh" {
  description = "Allow SSH and http inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "app from internet"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }

  egress {
    description = "http from internet"
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

  tags = {
    Name = "allow_http_ssh"
  }
}

resource "aws_security_group" "allow_postgres" {
  description = "allow postgres"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "postgres from app"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Creates the postgres db with desired parameters
resource "aws_db_instance" "data" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "10.17"
  instance_class         = "db.t2.micro"
  name                   = "postgres"
  username               = "postgres"
  password               = "postgres"
  skip_final_snapshot    = true
  port                   = 5432
  db_subnet_group_name   = aws_db_subnet_group.data_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id, aws_security_group.allow_postgres.id]
}

