# aws-demo
# Create EC2 using AWS Cloudformation

To get started/introduced to AWS CloudFormation refer below
    https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html

AWS Cloudformation stacks can be created using designer interface or through AWS CLI.
In this section, our focus is to use AWS CLI.

Install CLI using  https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html

Steps to create EC2 Instance:

1. Download the json file from this repo -   ec2-with-security-group-cf.json.
    Update the json file to configure as needed. 

2. Run below command (Modify the parameters present in {})
    
    //TODO - Pass region as a parameter as well
    
    aws cloudformation create-stack --stack-name {STACK_NAME} --template-body file://ec2-with-security-group-cf.json --parameters ParameterKey=KeyName,ParameterValue={KEY_NAME} ParameterKey=InstanceType,ParameterValue=t2.micro

Example: 

    aws cloudformation create-stack --stack-name ec2-with-security-group-cf --template-body file://ec2-with-security-group-cf.json --parameters ParameterKey=KeyName,ParameterValue=myfirstec2instance ParameterKey=InstanceType,ParameterValue=t2.micro

* If a key pair is not available, you can create it in EC2 dashboard.

After the Stack is created, you can SSH into EC2 instace using below


    ssh -i "myfirstec2instance.pem" ec2-user@{GET_EC2_INSTANCE_PUBLIC_DNS}
    


To delete Stack


    aws cloudformation delete-stack --stack-name ec2-with-security-group-cf
    
