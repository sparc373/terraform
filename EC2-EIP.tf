provider "aws" {
  access_key = "=================="
  secret_key = "============================"
  region     = "us-east-1"
}

resource "aws_instance" "myserver" {
  ami           = "ami-02f3f602d23f1659d"
  instance_type = "t2.micro"
}


#Create an Elastic IP
resource "aws_eip" "myserver-eip" {
  vpc = true
}

#Associate EIP with EC2 Instance
resource "aws_eip_association" "eip-association" {
  instance_id   = aws_instance.myserver.id
  allocation_id = aws_eip.myserver-eip.id
}

output "elastic_ip" {
  value = aws_eip.myserver-eip.public_ip
}
