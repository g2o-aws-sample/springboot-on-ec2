In this mini lab/lesson we are going to provision an EC2 using Hashicorps's terraform.

Reference:
https://www.terraform.io/docs/providers/aws/index.html

## What is Terraform? 

Terraform is a tool made by Hashicorp for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers ( aws, azure, Google cloud) as well as custom in-house solutions.

You can compare **Terraform** to **Cloudformation**
. They are simililar but at the same time have differences.

## Setting up with Amazon
### Sign up for AWS
When you sign up for AWS, your AWS account is automatically signed up for all services, including Amazon EC2. You are charged only for the services that you use.
If you have an AWS account already, skip to the [next task](#Create-an-IAM-user). If you don't have an AWS account, use the following procedure to create one.

To create an AWS account
•	Open https://portal.aws.amazon.com/billing/signup.
•	Follow the online instructions. For the sake of this demo you do not need to enter credit card information, you can simply sign into your account without giving the credit card info.

### Create an IAM user
Services in AWS, such as Amazon EC2, require that you provide credentials when you access them, so that the service can determine whether you have permission to access its resources. The console requires your password. You can create access keys for your AWS account to access the command line interface or API. However, we don't recommend that you access AWS using the credentials for your AWS account; we recommend that you use AWS Identity and Access Management (IAM) instead. Create an IAM user, and then add the user to an IAM group with administrative permissions or grant this user administrative permissions. You can then access AWS using a special URL and the credentials for the IAM user.

If you signed up for AWS but have not created an IAM user for yourself, you can create one using the IAM console.
**To create an administrator user for yourself and add the user to an administrators’ group (console)**
* Use your AWS account email address and password to sign in as the AWS account root user to the IAM console at https://console.aws.amazon.com/iam/.
* In the navigation pane, choose **“Users”** and then choose **“Add user”**.
* For **“Username”**, enter **“Administrator”**.
* Select the check box next to **“AWS Management Console access”**. Then select **“Custom password”**, and then enter your new password in the text box.
* (Optional) By default, AWS requires the new user to create a new password when first signing in. You can clear the check box next to **“User must create a new password at next sign-in”** to allow the new user to reset their password after they sign in.
* Choose **“Next: Permissions”**.
* Under **“Set permissions”**, choose **“Add user to group”**.
* Choose **“Create group”**.
* In the **“Create group”** dialog box, for **“Group name”** enter **“Administrators”** .
* Choose Filter policies, and then select **"AWS managed -job function"** to filter the table contents.
* In the policy list, select the check box for **“AdministratorAccess”**. Then choose **“Create group”**.
* Back in the list of groups, select the check box for your new group. Choose **“Refresh”** if necessary to see the group in the list.
* Choose **“Next: Tags”**.
* Choose **“Next: Review”** to see the list of group memberships to be added to the new user. When you are ready to proceed, choose **“Create user”**.

You can use this same process to create more groups and users and to give your users access to your AWS account resources. To learn about using policies that restrict user permissions to specific AWS resources, see [Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/access.html) and [Example Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html).

To sign in as this new IAM user, sign out of the AWS console, then use the following URL, where `your_aws_account_id` is your AWS account number without the hyphens (for example, if your AWS account number is `1234-5678-9012`, your AWS account ID is `123456789012`). To find out what your account id is, in the top right, select your username and choose **“My Account”**, the **“Account Id”** should be at the top of the page:

`https://`**your_aws_account_id**`.signin.aws.amazon.com/console/`

Enter the IAM username and password that you just created. When you're signed in, the navigation bar displays `”your_user_name @ your_aws_account_id”`.

If you don't want the URL for your sign-in page to contain your AWS account ID, you can create an account alias. From the IAM dashboard, choose **“Customize”** and enter an **“Account Alias”**, such as your company name. For more information, see [Your AWS Account ID and Its Alias](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html) in the IAM User Guide.

To sign in after you create an account alias, use the following URL:

`https://`**your_account_alias**`.signin.aws.amazon.com/console/`

To verify the sign-in link for IAM users for your account, open the IAM console and check under **“IAM users sign-in link”** on the dashboard.

### Creating the Access Key for AWS CLI
* In your IAM user account, select the user in top right and choose the **"My Security Credentials"** option
* In the **"Access keys for CLI, SDK, & API access"** section and select the **"Create Access Key"** button. 
* Copy the values from the **“Access Key ID”** and **“Secret Access Key”** and paste them in a text editor for later use.

## Configuring access to AWS using the CLI
Enter `aws configure` at the command line, and then press `Enter`. The AWS CLI outputs lines of text, prompting you to enter additional information. Enter each of your access keys in turn, and then press `Enter`. Then, enter an AWS Region name in the format shown, press `Enter`, and then press `Enter` a final time to skip the output format setting. The final `Enter` command is shown as replaceable text because there is no user input for that line. You should have gotten your access keys by following the [previous step](#Creating-the-Access-Key-for-AWS-CLI). If you’re in Ohio the region will be **“us-east-2”**
```bash
aws configure
AWS Access Key ID [None]: ''
AWS Secret Access Key [None]: ''
Default region name [None]: 'us-east-2'
Default output format [None]: ENTER
```

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
```
#### Note : EC2 AMI information
       AMI Name    : amzn-ami-hvm-2018.03.0.20200514.0-x86_64-gp2
       Source      : amazon/amzn-ami-hvm-2018.03.0.20200514.0-x86_64-gp2
       Description : Amazon Linux AMI 2018.03.0.20200514.0 x86_64 HVM gp2
       Platform    : Amazon Linux(Linux/UNIX)

7) initialize the working directory for terraform
```console 
terraform init
```

The terraform init command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

8) Provision the ec2 with this command
```console
terraform apply
```

9) Login to the AWS management console and navigate to the EC2 management console.  Check if the instance got provisioned


10) From your terminal/command prompt/ shell , destroy the resources
```console
terraform destroy
```
#### Note : Terminated EC2 instances will go away after a few hours. There is nothing you can do to manually remove them. Not to worry, you won't get billed for it.

That's it! you installed Terraform and used it to provision an EC2 instance. 

# References
* https://adamtheautomator.com/terraform-windows/
* https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html#awscli-install-windows-path
* https://www.terraform.io/docs/providers/aws/index.html#argument-reference

