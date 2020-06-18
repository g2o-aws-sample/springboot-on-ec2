In this mini lab/lesson we are going to provision an EC2 using Hashicorps's terraform.

Reference:
https://www.terraform.io/docs/providers/aws/index.html

## What is Terraform? 

Terraform is a tool made by Hashicorp for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers ( aws, azure, Google cloud) as well as custom in-house solutions.

You can compare **Terraform** to **Cloudformation**
. They are simililar but at the same time have differences.

### Steps to provision

1) Download the terraform binary file 
https://www.terraform.io/downloads.html

> If MAC users have `homebrew` installed on their machine:
> Just do: `brew install terraform`
> Go to step `5`

2) Extract the zip file
3) You will see the terraform binary executable  file 
4) make sure that the terraform binary is available on the PATH. 

For Mac/Linux. On the shell/terminal,  go to the folder where terraform binary is extracted 
```console
echo $"export PATH=\$PATH:$(pwd)" >> ~/.bash_profile
source ~/.bash_profile
```

For Windows users : follow this to add Terraform to PATH https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows

> If Windows users have `chocolatey` installed on their machine:
> Just do: `choco install -y terraform`
> Go to step `5`
> [Click here](https://chocolatey.org/docs/installation) for instructions to install `chocolatey`.

5) make a  new directory(can be named anything) and go inside the directory
```console
mkdir terraform-july && cd terraform-july
```

6) Paste this following code to a file called ec2example.tf( can be anything.tf)

#### minimal viable configuration

```HCL
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile 		          = "default"
  region                  = "us-east-2"
}

resource "aws_instance" "test-ec2" {
  ami           = "ami-083ebc5a49573896a"
  instance_type = "t2.micro"
  tags = {
    Name = "EC2-With-TerraForm"
  }
}
```

7) initialize the working directory for terraform
```console 
terraform init
```

"The terraform init command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times."

8) Provision the ec2 with this command
```console
terraform apply
```

9) Login to the AWS management console and navigate to the EC2 management console.  Check if the instance got provisioned


10) From your terminal/command prompt/ shell , destroy the resources
```console
terraform destroy
```


That's it! you installed Terraform and used it to provision an EC2 instance. 