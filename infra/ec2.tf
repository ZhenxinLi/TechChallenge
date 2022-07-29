resource "aws_key_pair" "deployer" {
  key_name   = "Servian-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "web_sg" {
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


/* • an EC2 instance named “web” deployed into private_az1 (use the latest Amazon Linux 
2 64-bit (x86) image and deploy a t2.micro instance size). */
/* • The “web” instance should allow ingress on the appropriate application port and SSH 
ingress on port 22 */
resource "aws_instance" "web" {
  ami             = data.aws_ami.Linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_sg.id]
  subnet_id       = aws_subnet.private_az1.id
  associate_public_ip_address = true
  key_name        = aws_key_pair.deployer.key_name

  tags = {
    Name = "Servian web"
  }
}

data "aws_ami" "Linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}