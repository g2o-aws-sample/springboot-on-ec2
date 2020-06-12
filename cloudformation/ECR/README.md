# aws-demo
# Create ECR using AWS Cloudformation

To get started/introduced to AWS CloudFormation refer below
    https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html

AWS Cloudformation stacks can be created using designer interface or through AWS CLI.
In this section, our focus is to use AWS CLI.

Install CLI using  https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html

Steps to create ECR :

1. Download the json file from this repo -   ecr-cf.json.
    Update the json file to configure as needed. 

2. Run below command 
    
    
    aws cloudformation create-stack --stack-name {STACK_NAME} --template-body file://ecr-cf.json 

Example: 

    aws cloudformation create-stack --stack-name ecr-with-cf --template-body file://ecr-cf.json 

   
To delete Stack


    aws cloudformation delete-stack --stack-name ecr-with-cf
    
 
 
 