# README

This repository contains the code to setup the Delivery Pipeline.

Proposed directory structure. Serves as a starting point.

### master  
Contains Docker file to create Jenkins Master image. The list of plugins needs to be cleaned up a little bit. Also I don't know if we want to install ruby and inspec in the master. That should be part of the slave.
Question: Do we publish this to an AWS repository for now or set up a repository in DockerHub?

### slave
Docker file to create Jenkins slave

### terraform/aws
Code to provision Jenkins in aws

### Useful commands
Build the docker image with:
``docker build -t scos/jenkins .```

To run Docker and skip the setup wizard
```docker run -d -p 8080:8080 -p 50000:50000 --name jenkins -e JAVA_OPTS=-Djenkins.install.runSetupWizard=false scos/jenkins```

To get list of installed plugins

```curl -sSL "http://localhost:8080/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'```


Goals:
* build a Jenkins master Docker image that meets the following criteria:
  * requires login (Active Directory/Github credentials/AWS Users - still have to decide on this)
  * has plugins installed. These include BlueOcean plugins and ec2 plugin (needs some cleanup)
  * has ec2 plugin configured automatically via groovy code (This may need to be environment specific)
  * AWS credentials are passed through the environment (this is needed for spinning up ECS instances from the master)
  * master URL needs to be accessible from the slaves (need to figure that one out)
* build a Jenkins slave Docker image that meets the following criteria:
  * has Docker installed
  * has inspec installed
  * has other dependencies like npm? Not sure at this point. Should we also consider building different types of slave images?
  * the idea is as we run the inspec tests it starts things like Grafana in a sibling Docker container
* provision Jenkins in AWS (I am looking for feedback here)
  * a VPC used by Continuous Delivery if needed(all this is Terraformed ideally)
  * setup public/private subnets or put all in a public subnet? (we are still protected by the VPN)
  * security groups
  * provision ECS instances
  * Jenkins master is accessible to developers through VPN
  * saves jenkins_home state in EFS (is this going to be a Docker volume?)
  * setup backup (future)
  * HA for Jenkins master(future)


  TODO:
  * Jenkins Master image
   * select cluster when Jenkins starts up - done
   * extract task definition template in separate file - done
   * configure Nexus so Jenkins can push to it
   * configure SCOS Github Repo so is automatically monitored
   * handle secrets with a Jenkins plugin for now
   * fix security warnings
   * configure LDAP
  * Jenkins Slave image
    * docker, terraform and inspec installed
    * other docker containers start as siblings - Jenkins has a docker plugin. How can we use it?
  * Terraform
    * EFS
    * move Jenkins to private subnets   
    * tune number of instances to start
    * implements scale up and scale down policies
    * configure Route 53
    * migrate ELB from classic
    * restring Jenkins access by IP?
  * Nexus TBD with Jeff
  * Jenkins file for sample repository - pick monitoring
    * runs docker inspec tests in a sibling docker container
    * publishes to Nexus if successful        
