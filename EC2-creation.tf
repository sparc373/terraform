provider "aws" {
  access_key = "================"
  secret_key = "====================="
  region     = "us-east-1"
}

resource "aws_instance" "myserver" {
  ami           = "ami-02f3f602d23f1659d"
  instance_type = "t2.micro"
}
