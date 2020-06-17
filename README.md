# aws-demo
### Create ECR Repo 
```
$ terraform init

Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

chanderson@ICC12044 MINGW64 /c/Users/chanderson/learn-terraform-aws-instance
$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_ecr_repository.caa-test will be created
  + resource "aws_ecr_repository" "caa-test" {
      + arn                  = (known after apply)
      + id                   = (known after apply)
      + image_tag_mutability = "MUTABLE"
      + name                 = "caa-test"
      + registry_id          = (known after apply)
      + repository_url       = (known after apply)
    }

  # aws_instance.example will be created
  + resource "aws_instance" "example" {
      + ami                          = "ami-b374d5a5"
      + arn                          = (known after apply)
      + associate_public_ip_address  = true
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = (known after apply)
      + network_interface_id         = (known after apply)
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_subnet.us-east-1a-public will be created
  + resource "aws_subnet" "us-east-1a-public" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "us-east-1a"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.0.1.0/25"
      + id                              = (known after apply)
      + ipv6_cidr_block                 = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = false
      + owner_id                        = (known after apply)
      + vpc_id                          = (known after apply)
    }

  # aws_vpc.example will be created
  + resource "aws_vpc" "example" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "10.0.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = true
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_ecr_repository.caa-test: Creating...
aws_vpc.example: Creating...
aws_ecr_repository.caa-test: Creation complete after 1s [id=caa-test]
aws_vpc.example: Creation complete after 3s [id=vpc-01ac31bc46f5f2823]
aws_subnet.us-east-1a-public: Creating...
aws_subnet.us-east-1a-public: Creation complete after 1s [id=subnet-06f134f24404601e2]
aws_instance.example: Creating...
aws_instance.example: Still creating... [10s elapsed]
aws_instance.example: Still creating... [20s elapsed]
aws_instance.example: Still creating... [30s elapsed]
aws_instance.example: Creation complete after 34s [id=i-07b031ef8c5c17643]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

caa-test-repo = 835696306510.dkr.ecr.us-east-1.amazonaws.com/caa-test
ip = 54.162.220.146

chanderson@ICC12044 MINGW64 /c/Users/chanderson/learn-terraform-aws-instance
$
```
### ECR Repo Created
### Push docker image
```
chanderson@ICC12044 MINGW64 /c/Users/chanderson/src/java-examples/spring-boot-docker-build (master)
$ aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 835696306510.dkr.ecr.us-east-1.amazonaws.com
Login Succeeded

chanderson@ICC12044 MINGW64 /c/Users/chanderson/src/java-examples/spring-boot-docker-build (master)
$ docker push 835696306510.dkr.ecr.us-east-1.amazonaws.com/caa-test:latest                                              The push refers to repository [835696306510.dkr.ecr.us-east-1.amazonaws.com/caa-test]
c6cf72eed6a5: Preparing
5361ab84586f: Preparing
7baab82bf7ad: Preparing
b4d9e44a598a: Preparing
5a72ca55944b: Preparing
7d2c4575c446: Preparing
2eaf0d58a380: Preparing
c2adabaecedb: Preparing
2eaf0d58a380: Waiting
c2adabaecedb: Waiting
7d2c4575c446: Waiting
5361ab84586f: Pushed
7baab82bf7ad: Pushed
b4d9e44a598a: Pushed
7d2c4575c446: Pushed
2eaf0d58a380: Pushed
c6cf72eed6a5: Pushed
c2adabaecedb: Pushed
5a72ca55944b: Pushed
latest: digest: sha256:d5a98dbb9cb50e714aab22193b601fb10b2319e6cf6007a3770cf4069df00f56 size: 1993
```
### Docker image pushed
### Pull and run docker image
```
[ec2-user@ip-172-31-63-76 ~]$ aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 835696306510.dkr.ecr.us-east-1.amazonaws.com
WARNING! Your password will be stored unencrypted in /home/ec2-user/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
[ec2-user@ip-172-31-63-76 ~]$ docker pull 835696306510.dkr.ecr.us-east-1.amazonaws.com/caa-test:latest
latest: Pulling from caa-test
54fec2fa59d0: Pull complete
b7dd01647a92: Pull complete
793cbc6f8a59: Pull complete
9a08b87df712: Pull complete
cb8c08ada2f5: Pull complete
52394e318040: Pull complete
0509b05519fe: Pull complete
6f82e549f0fa: Pull complete
Digest: sha256:d5a98dbb9cb50e714aab22193b601fb10b2319e6cf6007a3770cf4069df00f56
Status: Downloaded newer image for 835696306510.dkr.ecr.us-east-1.amazonaws.com/caa-test:latest
835696306510.dkr.ecr.us-east-1.amazonaws.com/caa-test:latest
[ec2-user@ip-172-31-63-76 ~]$ docker images
REPOSITORY                                              TAG                 IMAGE ID            CREATED             SIZE
835696306510.dkr.ecr.us-east-1.amazonaws.com/caa-test   latest              d8d53f9f2c9a        5 weeks ago         418MB

[ec2-user@ip-172-31-63-76 ~]$ docker run -d -p 8080:8080 835696306510.dkr.ecr.us-east-1.amazonaws.com/caa-test:latest
8a43e815dd43bdebd13619549181856fbbedae7fc38fda18a8c32daf7080cd6b
[ec2-user@ip-172-31-63-76 ~]$ curl http://localhost:8080/customer/10
{"id":10,"name":"Customer10"}
[ec2-user@ip-172-31-63-76 ~]$
```
### Docker pulled and run from ECR
### Destroy created resources
```

chanderson@ICC12044 MINGW64 /c/Users/chanderson/learn-terraform-aws-instance
$ terraform.exe destroy
aws_ecr_repository.caa-test: Refreshing state... [id=caa-test]
aws_vpc.example: Refreshing state... [id=vpc-0788ed4a3386a7ed8]
aws_subnet.us-east-1a-public: Refreshing state... [id=subnet-03874fdfc3455c443]
aws_instance.example: Refreshing state... [id=i-085789fa650c1e5a5]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_ecr_repository.caa-test will be destroyed
  - resource "aws_ecr_repository" "caa-test" {
      - arn                  = "arn:aws:ecr:us-east-1:835696306510:repository/caa-test" -> null
      - id                   = "caa-test" -> null
      - image_tag_mutability = "MUTABLE" -> null
      - name                 = "caa-test" -> null
      - registry_id          = "835696306510" -> null
      - repository_url       = "835696306510.dkr.ecr.us-east-1.amazonaws.com/caa-test" -> null
      - tags                 = {} -> null

      - image_scanning_configuration {
          - scan_on_push = false -> null
        }
    }

  # aws_instance.example will be destroyed
  - resource "aws_instance" "example" {
      - ami                          = "ami-b374d5a5" -> null
      - arn                          = "arn:aws:ec2:us-east-1:835696306510:instance/i-085789fa650c1e5a5" -> null
      - associate_public_ip_address  = true -> null
      - availability_zone            = "us-east-1a" -> null
      - cpu_core_count               = 1 -> null
      - cpu_threads_per_core         = 1 -> null
      - disable_api_termination      = false -> null
      - ebs_optimized                = false -> null
      - get_password_data            = false -> null
      - hibernation                  = false -> null
      - id                           = "i-085789fa650c1e5a5" -> null
      - instance_state               = "running" -> null
      - instance_type                = "t2.micro" -> null
      - ipv6_address_count           = 0 -> null
      - ipv6_addresses               = [] -> null
      - monitoring                   = false -> null
      - primary_network_interface_id = "eni-0e159883433177ca8" -> null
      - private_dns                  = "ip-10-0-1-16.ec2.internal" -> null
      - private_ip                   = "10.0.1.16" -> null
      - public_dns                   = "ec2-52-90-142-14.compute-1.amazonaws.com" -> null
      - public_ip                    = "52.90.142.14" -> null
      - security_groups              = [] -> null
      - source_dest_check            = true -> null
      - subnet_id                    = "subnet-03874fdfc3455c443" -> null
      - tags                         = {} -> null
      - tenancy                      = "default" -> null
      - volume_tags                  = {} -> null
      - vpc_security_group_ids       = [
          - "sg-0b4a992edf1695b13",
        ] -> null

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_put_response_hop_limit = 1 -> null
          - http_tokens                 = "optional" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/sda1" -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - volume_id             = "vol-064cda49f584c36cb" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
    }

  # aws_subnet.us-east-1a-public will be destroyed
  - resource "aws_subnet" "us-east-1a-public" {
      - arn                             = "arn:aws:ec2:us-east-1:835696306510:subnet/subnet-03874fdfc3455c443" -> null
      - assign_ipv6_address_on_creation = false -> null
      - availability_zone               = "us-east-1a" -> null
      - availability_zone_id            = "use1-az6" -> null
      - cidr_block                      = "10.0.1.0/25" -> null
      - id                              = "subnet-03874fdfc3455c443" -> null
      - map_public_ip_on_launch         = false -> null
      - owner_id                        = "835696306510" -> null
      - tags                            = {} -> null
      - vpc_id                          = "vpc-0788ed4a3386a7ed8" -> null
    }

  # aws_vpc.example will be destroyed
  - resource "aws_vpc" "example" {
      - arn                              = "arn:aws:ec2:us-east-1:835696306510:vpc/vpc-0788ed4a3386a7ed8" -> null
      - assign_generated_ipv6_cidr_block = false -> null
      - cidr_block                       = "10.0.0.0/16" -> null
      - default_network_acl_id           = "acl-0a69356b84fb032e4" -> null
      - default_route_table_id           = "rtb-01aa3e9d02f5955e1" -> null
      - default_security_group_id        = "sg-0b4a992edf1695b13" -> null
      - dhcp_options_id                  = "dopt-0d306f0316707b7a8" -> null
      - enable_classiclink               = false -> null
      - enable_classiclink_dns_support   = false -> null
      - enable_dns_hostnames             = true -> null
      - enable_dns_support               = true -> null
      - id                               = "vpc-0788ed4a3386a7ed8" -> null
      - instance_tenancy                 = "default" -> null
      - main_route_table_id              = "rtb-01aa3e9d02f5955e1" -> null
      - owner_id                         = "835696306510" -> null
      - tags                             = {} -> null
    }

Plan: 0 to add, 0 to change, 4 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.example: Destroying... [id=i-085789fa650c1e5a5]
aws_ecr_repository.caa-test: Destroying... [id=caa-test]
aws_ecr_repository.caa-test: Destruction complete after 0s
aws_instance.example: Still destroying... [id=i-085789fa650c1e5a5, 10s elapsed]
aws_instance.example: Still destroying... [id=i-085789fa650c1e5a5, 20s elapsed]
aws_instance.example: Still destroying... [id=i-085789fa650c1e5a5, 30s elapsed]
aws_instance.example: Destruction complete after 30s
aws_subnet.us-east-1a-public: Destroying... [id=subnet-03874fdfc3455c443]
aws_subnet.us-east-1a-public: Destruction complete after 1s
aws_vpc.example: Destroying... [id=vpc-0788ed4a3386a7ed8]
aws_vpc.example: Destruction complete after 0s

Destroy complete! Resources: 4 destroyed.

chanderson@ICC12044 MINGW64 /c/Users/chanderson/learn-terraform-aws-instance
$
```
### Resources destroyed
