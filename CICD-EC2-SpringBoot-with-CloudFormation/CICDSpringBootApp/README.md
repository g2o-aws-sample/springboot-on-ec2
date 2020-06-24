# aws-demo
# Create CICD for SpringBoot application in EC2 Instance with CodeCommit,CodeBuild,CodeDeploy,CodePipeline
Step1: Create S3 bucket to store the repository created from code build and code deploy - need to be specified in step 4

Step2: Create code commit repository to store the repository code - need to be specified in step 4

Step3: Run CFN-EC2-Instance.yml in AWS Cloudformation console

This will create EC2 Instance using the cloudformation file
We create one Staging instance and one prod instance using this template.


Step4: Run  CI-CD-CodePipeline-ApprovalStage.yml in AWS Cloudformation console

we have to specify the following input to run this template 
1. ApplicationRepoName - Name of the repo which contains Rest Application.
2. ArtifactStoreS3Location - Name of the S3 bucket to store CodePipeline artifact (Create separately and specify the name here).
3. Email - Email address where CodePipeline sends pipeline notifications

This will create the following

1. CodeBuild
2. CodeDeploy
3. CodePipeline 
4. SNS Topic

Once this stack is created when ever we push a code to the code commit repo a build will be created it will be deployed to staging environment. An approval email will sent to the email id given. Once the approver approves this build will be pushed from staging to Prod.

