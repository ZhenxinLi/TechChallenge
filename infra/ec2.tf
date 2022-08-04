resource "aws_key_pair" "deployer" {
  key_name   = "Servian-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

// creates the web EC2 Instance
resource "aws_instance" "web" {
  ami             = data.aws_ami.Linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_http_ssh.id]
  subnet_id       = aws_subnet.private_az1.id
  associate_public_ip_address = true
  key_name        = aws_key_pair.deployer.key_name

  tags = {
    Name = "Servian web"
  }
}

// filtering the lastest Linux ami to use automatically
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