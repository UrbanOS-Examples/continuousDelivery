# Jenkins!

## How to build the Docker images and push it to ECR

The Elastic Container Registry (ECR) for the Application Lifecycle Managment (ALM) cluster is here: 
https://us-east-2.console.aws.amazon.com/ecs/home?region=us-east-2#/repositories/scos:jenkins-master#images;tagStatus=ALL

Click the "View Push Commands" button for instructions

You only have to do this in order to bootstrap the system.
Once you have a running Jenkins, the Jenkinsfile in this repository will build and push an image on every commit.

## How to run the terraform scripts that deploy Jenkins to AWS

+ Make sure you're in the ALM workspace for all these commands. The workspaces are set per directory. Use `terraform workspace list` to check which one you're in, and `terraform workspace select alm` to switch to the ALM workspace.

+ Make sure your AWS credentials work for the ALM VPC.

+ The terraform scripts need to be built in the following directories in the following order: `efs`, `mount_target` and `ecs`, the first time Jenkins is deployed. Afterwards, any changes to Jenkins can be deployed by running the commands only in `ecs`.  The commands are as follows:
  + `terraform init`
  + `terraform plan -var-file=variables/alm.tfvars -out <DIRECTORYNAME>.plan`
  + `terraform apply <DIRECTORYNAME>.plan`

## How to find the Jenkins URL

The URL you're looking for is the URL for the load balancer in front of the EC2 instance that Jenkins is on.

+ go to the [AWS url that lists clusters](https://us-east-2.console.aws.amazon.com/ecs/home?region=us-east-2#/clusters) 
+ click on the name of the Jenkins cluster, `delivery-pipeline-alm-jenkins-cluster`
+ click on the name of the Jenkins service, `jenkins-master`
+ In the Details tab, click on the link under 'Load Balancer Name'
+ The URl next to 'DNS Name' is the address that Jenkins is on.

## Running Locally Alongside Minikube

The docker-compose file in this directory puts us on the host network, so that we can simulate the way the ALM network interacts with other VPCs.

Share minikube's docker daemon with your host.

```bash
eval $(minikube docker-env)
```

Bring up Jenkins

```bash
docker-compose up -d
```

Jenkins will be running on port 8080 of minikube's IP address.

```bash
minikube ip
```