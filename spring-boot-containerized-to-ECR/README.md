# Table of Contents
* [Building a Spring Boot app container to deploy to ECR](#Building-a-Spring-Boot-app-container-to-deploy-to-ECR)
    * [Pre-requisites](#Pre-requisites)
        * [Creating the Spring Boot application](#Creating-the-Spring-Boot-application)
        * [Create the directory structure](#Create-the-directory-structure)
        * [Set up a Spring Boot app](#Set-up-a-Spring-Boot-app)
        * [Containerize it](#Containerize-it)
        * [Build a Docker image with Maven](#Build-a-Docker-image-with-Maven)
        * [Using Spring Profiles](#Using-Spring-Profiles)
        * [Debugging the application in a Docker container](#Debugging-the-application-in-a-Docker-container)
    * [Setting up with Amazon ECR](#Setting-up-with-Amazon-ECR)
        * [Sign up for AWS](#Sign-up-for-AWS)
        * [To create an AWS account](#To-create-an-AWS-account)
        * [Create an IAM user](#Create-an-IAM-user)
        * [Creating the Access Key for AWS CLI](#Creating-the-Access-Key-for-AWS-CLI)
    * [Configuring access to ECR using the CLI](#Configuring-access-to-ECR-using-the-CLI)
    * [Pushing Docker image to ECR](#Pushing-Docker-image-to-ECR)
        * [Authenticate to your default registry](#Authenticate-to-your-default-registry)
        * [Create a repository](#Create-a-repository)
        * [Push an image to Amazon ECR](#Push-an-image-to-Amazon-ECR)
        * [To tag and push an image to Amazon ECR](#To-tag-and-push-an-image-to-Amazon-ECR)
        * [Pull an image from Amazon ECR](#Pull-an-image-from-Amazon-ECR)
        * [To view repository information](#To-view-repository-information)
        * [Delete an image](#Delete-an-image)
        * [Delete a repository](#Delete-a-repository)
        * [Delete Docker image](#Delete-Docker-image)
* [References](#References)

 
# Building a Spring Boot app container to deploy to ECR
## Pre-requisites
* Your favorite IDE (I'm using Eclipse for this example)
* [JDK 1.8](https://www.oracle.com/java/technologies/javase-downloads.html) or higher
* [Maven 3.2](https://maven.apache.org/download.cgi) or higher
* [Docker](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)
* [AWS CLI](https://s3.amazonaws.com/aws-cli/AWSCLI64PY3.msi)
* [AWS](https://aws.amazon.com/) account

## Creating the Spring Boot application
This section describes how to develop a simple **“Hello World!”** web application that highlights some of Spring Boot’s key features. We use Maven to build this project, since most IDEs support it.

Before we begin, open a terminal, and run the following commands to ensure that you have valid versions of Java and Maven installed:
```bash
java -version
java version "1.8.0_102"
Java(TM) SE Runtime Environment (build 1.8.0_102-b14)
Java HotSpot(TM) 64-Bit Server VM (build 25.102-b14, mixed mode)
mvn -v
Apache Maven 3.5.4 (1edded0938998edf8bf061f1ceb3cfdeccf443fe; 2018-06-17T14:33:14-04:00)
Maven home: /usr/local/Cellar/maven/3.3.9/libexec
Java version: 1.8.0_102, vendor: Oracle Corporation
```
In the IDE of your choice create a new Maven project. In Eclipse the steps are as follows:
* Select **“File” > “New” > “Maven Project”**
* Select the **“Create a simple project”** checkbox and click **“Next”**
* In the **“Group Id”** field insert **“org.springframework”**
* In the **“Articfact Id”** field insert **“spring-boot-docker”**
* In the **“Version”** field make sure **“0.0.1-SNAPSHOT”** is selected and select **“Finish”**

### Create the directory structure
In a project directory of your choosing, create the following subdirectory structure and then edit the pom.xml file:
`└── src
    └── main
        └── java
            └── hello`

`pom.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.springframework</groupId>
    <artifactId>spring-boot-docker</artifactId>
    <version>0.1.0</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.0.RELEASE</version>
    </parent>

    <properties>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

### Set up a Spring Boot app
Now you can create a simple application create a new Class called “Application” in the following directory and add the following code:
`src/main/java/hello/Application.java`
```java
package hello;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class Application {

  @RequestMapping("/")
  public String home() {
    return "Hello Docker World";
  }

  public static void main(String[] args) {
    SpringApplication.run(Application.class, args);
  }
}
```
The class is flagged as a `@SpringBootApplication` and as a `@RestController`, meaning it’s ready for use by Spring MVC to handle web requests. `@RequestMapping` maps `/` to the `home()` method which just sends a **"Hello World"** response. The `main()` method uses Spring Boot’s `SpringApplication.run()` method to launch an application.

Now we can run the application without the Docker container (i.e. in the host OS). In the terminal cd into your project directory and type in the following command:
```bash
mvn package && java -jar target/spring-boot-docker-0.1.0.jar
```
and go to [localhost:8080](http://localhost:8080) to see your **"Hello Docker World"** message. To gracefully exit the application, press `ctrl-c`.
### Containerize it
Docker has a simple ["Dockerfile"](https://docs.docker.com/reference/builder/) file format that it uses to specify the **"layers"** of an image. So, let’s go ahead and create a Dockerfile in our Spring Boot project in the main directory:

`Dockerfile`
```
FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```

You can run it with the following command in the terminal while in the main directory:
```bash
docker build -t springio/spring-boot-docker .
```

This command builds an image and tags it as `springio/spring-boot-docker`.

This Dockerfile is very simple, but that’s all you need to run a Spring Boot app with no frills: just Java and a JAR file. The build will create a spring user and a spring group to run the application. It will then `Copy` the project JAR file into the container as "app.jar" that will be executed in the `ENTRYPOINT`. The array form of the Dockerfile `ENTRYPOINT` is used so that there is no shell wrapping the java process. The [Topical Guide on Docker](https://spring.io/guides/topicals/spring-boot-docker) goes into this topic in more detail.

Running applications with user privileges helps to mitigate some risks (see for example [a thread on StackExchange](https://security.stackexchange.com/questions/106860/can-a-root-user-inside-a-docker-lxc-break-the-security-of-the-whole-system)). So, an important improvement to the `Dockerfile` is to run the app as a non-root user:

`Dockerfile`
```
FROM openjdk:8-jdk-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```

Also, there is a clean separation between dependencies and application resources in a Spring Boot fat jar file, and we can use that fact to improve performance. The key is to create layers in the container filesystem. The layers are cached both at build time and at runtime (in most runtimes) so we want the most frequently changing resources, usually the class and static resources in the application itself, to be layered after the more slowly changing resources. Thus we will use a slightly different implementation of the Dockerfile:

`Dockerfile`
```
FROM openjdk:8-jdk-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
ARG DEPENDENCY=target/dependency
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","hello.Application"]
```

This Dockerfile has a `DEPENDENCY` parameter pointing to a directory where we have unpacked the fat jar.
```bash
cd target && mkdir dependency
cd dependency && jar -xf ../*.jar
```
If we get that right, it already contains a `BOOT-INF/lib` directory with the dependency jars in it, and a `BOOT-INF/classes` directory with the application classes in it. Notice that we are using the application’s own main class `hello.Application` (this is faster than using the indirection provided by the fat jar launcher).

To build the image you can use the Docker command line. For example: 
```bash
docker build -t springio/spring-boot-docker .
``` 

### Build a Docker image with Maven
To get started quickly, you can run the Spring Boot image generator without even changing your `pom.xml` (and remember the `Dockerfile` if it is still there is ignored):
```bash
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=springio/spring-boot-docker
```

You do NOT have to register with docker or publish anything to run a docker image that was built locally. If you built with Docker (from the command line or from Spring Boot), you still have a locally tagged image, and you can run it like this:
```bash
docker run -p 8080:8080 -t springio/spring-boot-docker
```

The application is then available on http://localhost:8080 (visit that and it says "Hello Docker World"). When it is running you can see in the list of containers, e.g:
```bash
docker ps
CONTAINER ID        IMAGE                                   COMMAND                  CREATED             STATUS              PORTS                    NAMES
81c723d22865        springio/spring-boot-docker:latest   "java -Djava.secur..."   34 seconds ago      Up 33 seconds       0.0.0.0:8080->8080/tcp   goofy_brown
```

###Using Spring Profiles
Running your freshly minted Docker image with Spring profiles is as easy as passing an environment variable to the Docker run command:
```bash
docker run -e "SPRING_PROFILES_ACTIVE=prod" -p 8080:8080 -t springio/spring-boot-docker
```
or
```bash
docker run -e "SPRING_PROFILES_ACTIVE=dev" -p 8080:8080 -t springio/spring-boot-docker
```

### Debugging the application in a Docker container
To debug the application JPDA Transport can be used. So, we’ll treat the container like a remote server. To enable this feature, pass a java agent setting in JAVA_OPTS variable and map agent’s port to localhost during a container run.
```bash
docker run -e "JAVA_TOOL_OPTIONS=-agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n" -p 8080:8080 -p 5005:5005 -t springio/spring-boot-docker
```

## Setting up with Amazon ECR
### Sign up for AWS
When you sign up for AWS, your AWS account is automatically signed up for all services, including Amazon ECR. You are charged only for the services that you use.
If you have an AWS account already, skip to the [next task](#Create-an-IAM-user). If you don't have an AWS account, use the following procedure to create one.

To create an AWS account
•	Open https://portal.aws.amazon.com/billing/signup.
•	Follow the online instructions. For the sake of this demo you do not need to enter credit card information, you can simply sign into your account without giving the credit card info.

### Create an IAM user
Services in AWS, such as Amazon ECR, require that you provide credentials when you access them, so that the service can determine whether you have permission to access its resources. The console requires your password. You can create access keys for your AWS account to access the command line interface or API. However, we don't recommend that you access AWS using the credentials for your AWS account; we recommend that you use AWS Identity and Access Management (IAM) instead. Create an IAM user, and then add the user to an IAM group with administrative permissions or grant this user administrative permissions. You can then access AWS using a special URL and the credentials for the IAM user.

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

## Configuring access to ECR using the CLI
Enter `aws configure` at the command line, and then press `Enter`. The AWS CLI outputs lines of text, prompting you to enter additional information. Enter each of your access keys in turn, and then press `Enter`. Then, enter an AWS Region name in the format shown, press `Enter`, and then press `Enter` a final time to skip the output format setting. The final `Enter` command is shown as replaceable text because there is no user input for that line. You should have gotten your access keys by following the [previous step](#Creating-the-Access-Key-for-AWS-CLI). If you’re in Ohio the region will be **“us-east-2”**
```bash
aws configure
AWS Access Key ID [None]: 'AKIAIOSFODNN7EXAMPLE'
AWS Secret Access Key [None]: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
Default region name [None]: 'us-east-2'
Default output format [None]: ENTER
```

## Pushing Docker image to ECR
### Authenticate to your default registry
After you have installed and configured the AWS CLI, authenticate the Docker CLI to your default registry. That way, the `docker` command can push and pull images with Amazon ECR. The AWS CLI provides a `get-login-password` command to simplify the authentication process.

To authenticate Docker to an Amazon ECR registry with `get-login-password`, run the `aws ecr get-login-password` command. When passing the authentication token to the docker login command, use the value `AWS` for the username and specify the Amazon ECR registry URI you want to authenticate to. If authenticating to multiple registries, you must repeat the command for each registry, `region` will be `us-east-2` if you are in Ohio. Make sure Docker is running when you run this command.
```bash
aws ecr get-login-password --region region | docker login --username AWS --password-stdin 'aws_account_id'.dkr.ecr.region.amazonaws.com
```

### Create a repository
Now that you have an image to push to Amazon ECR, you must create a repository to hold it. In this example, you create a repository called `hello-world` to which you later push the `springio/spring-boot-docker:latest` image. To create a repository, run the following command:
```bash
aws ecr create-repository --repository-name hello-world --image-scanning-configuration scanOnPush=true --region us-east-2
```

### Push an image to Amazon ECR
Now you can push your image to the Amazon ECR repository you created in the previous section. You use the **docker** CLI to push images, but there are a few prerequisites that must be satisfied for this to work properly:
* The minimum version of **docker** is installed: 1.7
* The Amazon ECR authorization token has been configured with **docker login**.
* The Amazon ECR repository exists, and the user has access to push to the repository.

After those prerequisites are met, you can push your image to your newly created repository in the default registry for your account.

### To tag and push an image to Amazon ECR
* List the images you have stored locally to identify the image to tag and push.
```bash
docker images
```
Output:
```bash
REPOSITORY	TAG	IMAGE ID	CREATED		VIRTUAL SIZE
Hello-world	latest	e9ffedc8c286	4 minutes ago	241 MB
```
* Tag the image to push to your repository.
```bash
docker tag springio/spring-boot-docker:latest aws_account_id.dkr.ecr.us-east-2.amazonaws.com/hello-world:latest
```
* Push the image.
```bash
docker push aws_account_id.dkr.ecr.us-east-2.amazonaws.com/hello-world:latest
```
Output:
```bash
The push refers to a repository [aws_account_id.dkr.ecr.us-east-2.amazonaws.com/hello-world] (len: 1)
e9ae3c220b23: Pushed
a6785352b25c: Pushed
0998bf8fb9e9: Pushed
0a85502c06c9: Pushed
latest: digest:
sha256:215d7e4121b30157d8839e81c4e0912606fca105775bb0636b95aed25f52c89 size:
6774
```

### Pull an image from Amazon ECR
After your image has been pushed to your Amazon ECR repository, you can pull it from other locations. Use the **docker** CLI to pull images, but there are a few prerequisites that must be satisfied for this to work properly:
* The minimum version of **docker** is installed: 1.7
* The Amazon ECR authorization token has been configured with **docker login**.
* The Amazon ECR repository exists, and the user has access to pull from the repository.

After those prerequisites are met, you can pull your image. To pull your example image from Amazon ECR, run the following command:
```bash
docker pull aws_account_id.dkr.ecr.us-east-2.amazonaws.com/hello-world:latest
```
Output:
```bash
latest: Pulling from hello-world
e9ae3c220b23: Pull complete
a6785352b25c: Pull complete
0998bf8fb9e9: Pull complete
0a85502c06c9: Pull complete
Digest: sha256:215d7e4121b30157d8839e81c4e0912606fca105775bb0636b95aed25f52c89b
Status: Downloaded newer image for aws_account_id.dkr.ecr.us-east-2.amazonaws.com/hello-world:latest
```

To view repository information
* Open the Amazon ECR console at https://console.aws.amazon.com/ecr/repositories.
* From the navigation bar, choose the Region that contains the repository to view.
* In the navigation pane, choose Repositories.
* On the Repositories page, choose the repository to view.
* On the **“Repositories :`repository_name`“** page, use the navigation bar to view information about an image.
* Choose **“Images”** to view information about the images in the repository. If there are untagged images that you would like to delete, you can select the box to the left of the repositories to delete and choose **“Delete”**. For more information, see [Deleting an image](https://docs.aws.amazon.com/AmazonECR/latest/userguide/delete_image.html).
* Choose **“Permissions”** to view the repository policies that are applied to the repository. For more information, see [Amazon ECR Repository Policies](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policies.html).
* Choose **“Lifecycle Policy”** to view the lifecycle policy rules that are applied to the repository. The lifecycle events history is also viewed here. For more information, see [Amazon ECR Lifecycle Policies](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html).
* Choose **“Tags”** to view the metadata tags that are applied to the repository.

### Delete an image
If you decide that you no longer need or want an image in one of your repositories, you can delete it with the `batch-delete-image` command. To delete an image, you must specify the repository that it is in and either an `imageTag` or `imageDigest` value for the image. The example below deletes an image in the `hello-world` repository with the image tag `latest`.
```bash
aws ecr batch-delete-image --repository-name hello-world --image-ids imageTag=latest
```
Output:
```bash
{
  “failures”: [],
  “imageIds”: [
    {
	“imageTag”: “latest”,
	“imageDigest”: “sha256:215d7e4121b30157d8839e81c4e0912606fca105775bb0636b95aed25f52c89b”
   }
  ]
}
```

### Delete a repository
If you decide that you no longer need or want an entire repository of images, you can delete the repository. By default, you cannot delete a repository that contains images; however, the `--force` flag allows this. To delete a repository that contains images (and all the images within it), run the following command.
```bash
aws ecr delete-repository --repository-name hello-world –force
```

### Delete Docker image
Run the `docker ps` command to get the list of images running in Doker:
```bash
docker ps
CONTAINER ID        IMAGE                                   COMMAND                  CREATED             STATUS              PORTS                    NAMES
81c723d22865        springio/spring-boot-docker:latest   "java -Djava.secur..."   34 seconds ago      Up 33 seconds       0.0.0.0:8080->8080/tcp   goofy_brown
```
To shut it down your Docker image you can `docker stop` with the container ID from the listing above (yours will be different):
```bash
docker stop goofy_brown
81c723d22865
```
If you like you can also delete the container (it is persisted in your filesystem under `/var/lib/docker` somewhere) when you are finished with it:
```bash
docker rm goofy_brown
```
 
# References
* https://docs.spring.io/spring-boot/docs/current/reference/html/getting-started.html#getting-started-first-application
* https://spring.io/guides/gs/spring-boot-docker/
* https://docs.aws.amazon.com/AmazonECR/latest/userguide/get-set-up-for-amazon-ecr.html
* https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
* https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html#cli-create-image
* https://maven.apache.org/install.html