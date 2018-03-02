#README

This repository will contain the code to setup the Delivery Pipeline. This structure is not set in stone and serves just a starting point.

### master  
Contains Docker file to create Jenkins Master image. The list of plugins needs to be cleaned up a little bit. Also I don't know if we want to install ruby and inspec in the master. That should be part of the slave.
Question: Do we publish this to an AWS repository for now or set up a repository in DockerHub?

### slave
Docker file to create Jenkins slave

### terraform/AWS
Code to provision Jenkins in aws

### Useful commands
To run Docker and skip the setup wizard
```docker run -d -p 8080:8080 -p 50000:50000 --name jenkins -e JAVA_OPTS=-Djenkins.install.runSetupWizard=false scos/jenkins```

To get list of installed plugins

```curl -sSL "http://localhost:8080/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'```


Goals:
* build a Jenkins master Docker image that meets the following criteria:
  * requires login (Active Directory/Github credentials/AWS Users - still have to decide on this)
  * has required plugins installed (needs some cleanup)
  * has BlueOcean installed
  * has ec2 plugin installed and configured automatically (This may need to be environment specific)
  * need to figure out how to pass AWS credentials through the environment (this is needed for spinning up ECS instances from the master)
  * master URL needs to be accessible from the slaves (need to figure that one out)
* build a Jenkins slave Docker image that meets the following criteria:
  * has Docker installed
  * has inspec installed
  * other dependencies like npm? Not sure at this point
  * the idea is as we run the tests it starts things Grafana in a  sibling Docker container and run inspec tests against it
* provision Jenkins in AWS (I am looking for feedback here)
  * a VPC used by Continous Delivery if needed for the CI/CD pipeline (all this is Terraformed ideally)
  * setup subnets or all is in a public subnet
  * security groups
  * Jenkins master is accessible for developers through VPN
  * saves jenkins_home state in EFS (should it use a Docker volume?)
  * has backup setup (future)
