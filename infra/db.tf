resource "aws_security_group" "db_sg" {
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
    description = "appropriate database port"
    from_port   = 5432
    to_port     = 5432
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

resource "aws_instance" "db" {
  ami             = data.aws_ami.Linux.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.data_az1.id
  security_groups = [aws_security_group.db_sg.id]
  associate_public_ip_address = true
  key_name        = aws_key_pair.deployer.key_name

  tags = {
    Name = "Servian db"
  }
}

