# infra-test

This repo contains the code needed in terraform to create the infrastructure to run a web application (Go) on AWS.

The web application is located in the test-app/ directory. Its only requirements are to be able to connect to a PostgreSQL database and perform PING requests.

In addition, there's a CI/CD solution implemented with GitHub actions (.github/workflows directory) to build and deploy any change that the application may have.

## Architecture

This diagram, it's a high level view of all the different components involved in the solution:

![AWS-diagram](https://user-images.githubusercontent.com/80314345/234810523-f60088df-facc-432f-8162-b947b4e9e071.jpg)

The solution is based in containers, so there's a Dockerfile in the repo to build the image. I'm using an ECR to store the application images, and an ECS cluster to run it. I added an autoscaler for the ECS cluster to increase or decrease the number of containers in function of the load (CPU usage). There's also an RDS (PostgreSQL) for the application to perform the ping. I also added to the solution an Application Load Balancer to distribute the different requests between all the containers in the cluster.

The solution is divided in 3 different subnets, one of them is exposed to the Internet (Public) and the others are not. Only the ECR and the Application load balancer are in the public subnet, those are the only resources that are exposed to the Internet. The ECS cluster and the PostgreSQL are on two different subnets, one each.

There's also other resources to ensure the connectivity between all the different pieces of the solution: Internet Gateway, NAT gateway, etc.

## Inicialization

To start building all the solution, you have to execute the classical terraform commands (terraform init, terraform plan, etc), parametrized with the "dev.tfvars" as a variables file:

```
terraform init
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

Once Terraform has finished with his job, all the infrastructure will be created. The only thing that you have to do (or the CI/CD) is building the image and pushing it to the ECR. With that, the ECS will automatically pick the image and create a new container.


## Scaling the service

As already metioned there's an autoscaler in the ECS cluster to increase the amount of pods, with that you can face higher demands on the application. If that's not enough, you can increase the limits of the autoscaler. 

Another situation is that you already know that you're going to have a larger audience, in that case you can increase  the number of the desired tasks in the ECS cluster, it will create new containers to distribute the load among them. No additional action is needed, the Application load balancer will distribute the load among all of them.


## CI/CD

I have created a CI/CD solution based on GitHub actions to deploy the application when it has some changes with 0 downtime. The solution builds the new image with the Dockerfile, and after that the image is pushed to the ECR repo. The next step is to download the current task definition from the ECS cluster. It changes the tag with the new build number, and push the new definition to the cluster. The ECS will do a green/blue deployment for the task with 0 downtime.   
