provider "aws" {
  version    = "~> 2.64"
  profile = "default"
  region  = "us-east-2"
}

resource "aws_key_pair" "react-app" {
  key_name   = "sshkey"
  public_key = file("c:/Users/chanderson/.ssh/terraform.pub")
}

resource "aws_instance" "react-app" {
  key_name      = aws_key_pair.react-app.key_name
  ami           = "ami-083ebc5a49573896a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.us-east-2a-public.id
  security_groups = [aws_security_group.ingress-ssh-test.id]
  associate_public_ip_address = true

  tags = {
    Name = "EC2-remote-exec"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("c:/Users/chanderson/.ssh/terraform")
    host        = self.public_ip
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install docker",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user"
    ]
  }
}

resource "aws_security_group" "ingress-ssh-test" {
  name = "allow-ssh-sg"
  vpc_id = aws_vpc.react-app.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "react-app" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_eip" "ip-react-app" {
  instance = aws_instance.react-app.id
  vpc      = true
}

resource "aws_subnet" "us-east-2a-public" {
  vpc_id = aws_vpc.react-app.id
  cidr_block = cidrsubnet(aws_vpc.react-app.cidr_block, 3, 1)
  availability_zone = "us-east-2a"
}

resource "aws_internet_gateway" "react-app-gw" {
  vpc_id = aws_vpc.react-app.id
}

resource "aws_route_table" "route-table-react-app" {
  vpc_id = aws_vpc.react-app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.react-app-gw.id
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.us-east-2a-public.id
  route_table_id = aws_route_table.route-table-react-app.id
}

output "hostname" {
  value = aws_eip.ip-react-app.public_dns
}

output "ip" {
  value = aws_eip.ip-react-app.public_ip
}

resource "aws_ecr_repository" "react-app-repo" {
  name = "react-app-repo"
}

output "react-app-repo" {
  value = aws_ecr_repository.react-app-repo.repository_url
}
