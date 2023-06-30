provider "aws" {
  access_key = "===================="
  secret_key = "=============================="
  region     = "us-east-1"
  alias      = "east1"
}

provider "aws" {
  access_key = "==============="
  secret_key = "========================="
  region     = "us-east-2"
  alias      = "east2"
}


resource "aws_instance" "myserver-o" {
  ami           = "ami-02f97949d306b597a"   ### Replace AMI as per Intance w.r.t to Region
  instance_type = "t2.micro"
  provider      = aws.east2
  tags = {
    Name = "hello-ohio"   ## Replace Name Tag as required
  }
}

resource "aws_instance" "myserver-n" {
  ami           = "ami-00c39f71452c08778"   ### Replace AMI as per Intance w.r.t to Region
  instance_type = "t2.micro"
  provider      = aws.east1
  tags = {
    Name = "hello-virginia" ## Replace Name Tag as required
  }
}

