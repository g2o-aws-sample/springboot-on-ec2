provider "aws" {
  version    = "~> 2.64"
  region     = "us-east-1"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}

resource "aws_instance" "example" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.us-east-1a-public.id
  associate_public_ip_address = true
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "us-east-1a-public" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/25"
  availability_zone = "us-east-1a"
}

output "ip" {
  value = aws_instance.example.public_ip
}

resource "aws_ecr_repository" "caa-test" {
  name = "caa-test"
}

output "caa-test-repo" {
  value = aws_ecr_repository.caa-test.repository_url
}