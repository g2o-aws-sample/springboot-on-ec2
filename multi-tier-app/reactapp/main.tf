provider "aws" {
  version = "~> 2.64"
  profile = "default"
  region  = var.aws_region
}

# aws region
variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-east-2"
}

# public key for ec2 instance
resource "aws_key_pair" "react-app" {
  key_name   = "sshkey"
  public_key = file("c:/Users/chanderson/.ssh/terraform.pub")
}

# create EC2 instance with public key, public IP, security group
# that allows ssh & http connections, iam role for aws ecr access
# update instance, install docker, and configure for aws credentials
# from Ec2InstanceMetadata
resource "aws_instance" "react-app" {
  key_name      = aws_key_pair.react-app.key_name
  ami           = "ami-083ebc5a49573896a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.us-east-2a-public.id
  security_groups = [aws_security_group.react-app-sg.id]
  iam_instance_profile = aws_iam_instance_profile.react-app-profile.name
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
      "sudo usermod -a -G docker ec2-user",
      "mkdir .aws",
      "echo -e '[default]\nrole_arn = ${aws_iam_role.react-app-role.arn}\ncredential_source = Ec2InstanceMetadata' > .aws/credentials",
      "echo -e '[default]\nregion = ${var.aws_region}\n' > .aws/config",
      "echo \"alias docker_login='aws ecr get-login-password | docker login --username AWS --password-stdin ${aws_ecr_repository.react-app-repo.repository_url}'\" >> .bashrc"
    ]
  }
}

# IAM role policy for assumeRole
data "aws_iam_policy_document" "react-app-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# instance IAM role
resource "aws_iam_role" "react-app-role" {
  name = "react-app-role"

  assume_role_policy = data.aws_iam_policy_document.react-app-role-policy.json
}

# IAM instance profile
resource "aws_iam_instance_profile" "react-app-profile" {
  name = "react-app-profile"
  role = aws_iam_role.react-app-role.name
}

# IAM policy document for instance ecr access
data "aws_iam_policy_document" "react-app-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

# IAM policy using policy document
resource "aws_iam_role_policy" "react-app-policy" {
  name = "react-app-policy"
  role = aws_iam_role.react-app-role.id

  policy = data.aws_iam_policy_document.react-app-policy.json
}

# security group to allow SSH & HTTP access
resource "aws_security_group" "react-app-sg" {
  name = "react-app-sg"
  vpc_id = aws_vpc.react-app.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# virtual private cloud for EC2 instance
resource "aws_vpc" "react-app" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

# attach elastic IP  to EC2 instance
resource "aws_eip" "ip-react-app" {
  instance = aws_instance.react-app.id
  vpc      = true
}

# subnet for vpc
resource "aws_subnet" "us-east-2a-public" {
  vpc_id = aws_vpc.react-app.id
  cidr_block = cidrsubnet(aws_vpc.react-app.cidr_block, 3, 1)
  availability_zone = "us-east-2a"
}

# internet gateway route for vpc
resource "aws_internet_gateway" "react-app-gw" {
  vpc_id = aws_vpc.react-app.id
}

# default route to gateway
resource "aws_route_table" "route-table-react-app" {
  vpc_id = aws_vpc.react-app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.react-app-gw.id
  }
}

# associate route table to subnet
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.us-east-2a-public.id
  route_table_id = aws_route_table.route-table-react-app.id
}

# ECR docker repository
resource "aws_ecr_repository" "react-app-repo" {
  name = "react-app-repo"
}

output "hostname" {
  value = aws_eip.ip-react-app.public_dns
}

output "ip" {
  value = aws_eip.ip-react-app.public_ip
}

output "react-app-repo" {
  value = aws_ecr_repository.react-app-repo.repository_url
}

output "ec2-role-arn" {
    value = aws_iam_role.react-app-role.arn
}
