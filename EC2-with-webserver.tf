provider "aws" {
  access_key = "============================="
  secret_key = "=========================================="
  region     = "us-east-1"
}

resource "aws_vpc" "MyVpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "MyPubSub" {
  vpc_id     = aws_vpc.MyVpc.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_internet_gateway" "MyIG" {
  vpc_id = aws_vpc.MyVpc.id
}
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.MyVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIG.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.MyIG.id
  }
}

resource "aws_route_table_association" "pub_1_rt_a" {
  subnet_id      = aws_subnet.MyPubSub.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.MyVpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "web1" {
  public_key = file("/home/cloud_user/.ssh/id_rsa.pub")
}


resource "aws_instance" "web_instance" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2-server"
  }

  subnet_id                   = aws_subnet.MyPubSub.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
}

#Create an Elastic IP
resource "aws_eip" "web_instance-eip" {
  vpc = true
}
