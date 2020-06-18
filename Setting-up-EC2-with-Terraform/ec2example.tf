provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile 		  = "default"
  region                  = "us-east-2"
}

resource "aws_instance" "test-ec2" {
  ami           = "ami-083ebc5a49573896a"
  instance_type = "t2.micro"
  tags = {
    Name = "EC2-With-TerraForm"
  }
}