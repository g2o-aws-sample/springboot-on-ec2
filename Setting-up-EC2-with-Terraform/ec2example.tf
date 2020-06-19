# Terraform Version   : Terraform v0.12.26 (provider.aws v2.66.0)
# AWS CLI Version     : aws-cli/2.0.22 Python/3.7.7 Windows/10 botocore/2.0.0dev26

provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile 		          = "default"
  region                  = "us-east-2"
}


# AMI Name    : amzn-ami-hvm-2018.03.0.20200514.0-x86_64-gp2
# Source      : amazon/amzn-ami-hvm-2018.03.0.20200514.0-x86_64-gp2
# Description : Amazon Linux AMI 2018.03.0.20200514.0 x86_64 HVM gp2
# Platform    : Amazon Linux(Linux/UNIX)

resource "aws_instance" "test-ec2" {
  ami           = "ami-083ebc5a49573896a"
  instance_type = "t2.micro"
  tags = {
    Name = "EC2-With-TerraForm"
  }
}
