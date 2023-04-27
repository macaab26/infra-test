# infra-test

This repo contains the code needed in terraform to create the infrastructure to run a web application (Go) on AWS.

The web application is located in the test-app/ directory. Its only requirements are to be able to connect to a PostgreSQL database and perform PING requests.

In addition, there's a CI/CD solution implemented with GitHub actions (.github/workflows directory) to build and deploy any change that the application may have.

## Architecture

This diagram, it's a high level view of all the different components involved in the solution:

![AWS-diagram](https://user-images.githubusercontent.com/80314345/234810523-f60088df-facc-432f-8162-b947b4e9e071.jpg)

The solution is based in containers, so there's a Dockerfile in the repo to build the image. I'm using an ECR to store the application images, and an ECS cluster to run it. There's also an RDS (PostgreSQL) for the application to perform the ping. I also added to the solution an Application Load Balancer to distribute the different requests between all the containers in the cluster.

The solution is divided in 3 different subnets, one of them is exposed to the Internet (Public) and the others are not. Only the ECR and the Application load balancer are in the public subnet, those are the only resources that are exposed to the Internet. The ECS cluster and the PostgreSQL are on two different subnets, one each.

There's also other resources to ensure the connectivity between all the different pieces of the solution: Internet Gateway, NAT gateway, etc.

## Inicialization


Provide basic architecture diagrams and documentation on how to initialise the infrastructure along with any other documentation you think is appropriate
Provide and document a mechanism for scaling the service and delivering the application to a larger audience
Describe a possible solution for CI and/or CI/CD in order to release a new version of the application to production without any downtime
