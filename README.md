# README

This repository contains the code to setup the Delivery Pipeline.

Proposed directory structure. Serves as a starting point.

### master

Contains Docker file to create Jenkins Master image with custom startup scripts.

### jenkins_workers

Docker file to create Jenkins worker nodes

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
   * configure Nexus so Jenkins can push to it:  http://codeheaven.io/using-nexus-3-as-your-repository-part-3-docker-images/
   * configure SCOS Github Repo so is automatically monitored
   * handle secrets with a Jenkins plugin for now
   * fix security warnings
   * configure LDAP
  * Jenkins Slave image
    * docker, terraform and inspec installed
    * other docker containers start as siblings - Jenkins has a docker plugin. How can we use it?
  * Terraform
    * EFS for Jenkins - done
    * move Jenkins to private subnets   - done  
    * tune number of instances to start
    * implements scale up and scale down policies
    * configure Route 53
    * migrate ELB from classic
    * restrict Jenkins access by IP?
    * extract LB variables - done
    * use EC2 image that has up to date ECS agent - done
  * Nexus
    * Nexus confirmation of EFS persistence by restarting Nexus container and confirming configuration remains - done
    * Nexus setup of LDAP
    * Change Nexus local admin password from its default setting - DONE
    * Change Nexus script to same approach used by Jenkins - DONE
  * Jenkins file for sample repository - pick monitoring
    * runs docker inspec tests in a sibling docker container
    * publishes to Nexus if successful    
  * Other  
    * Resolve conflict with the elb security group name.
    * Consider an approach where security groups are reusable. E.g. use same security groups for Delivery Pipeline load balancers    


## Upgrading Jenkins Master
Sometimes the number of security errors and warning under the "Manage Jenkins" page get a little high. Here is how to deal with this:

1. Log in to Jenkins
2. Go to Jenkins > Manage Jenkins in the toolbar on the left
![image](https://user-images.githubusercontent.com/31485710/79465695-b466a000-7fc9-11ea-96fd-8c3e362ea02b.png)
3. Let people know you are working on Jenkins updates and click on the "Prepare to Shutdown" button towards the bottom of the screen to put Jenkins into a mode where it won't run new builds.
![image](https://user-images.githubusercontent.com/31485710/79466475-a402f500-7fca-11ea-8af8-0295603fcad8.png)
4. If Jenkins has a warning near the top of the screen about the Jenkins version itself needing updates, then click on the "Update automatically" button it presents to you and wait for it to update and reboot.
5. Click on the "Manage Plugins" button to get a list of all the plugins needing updates.
![image](https://user-images.githubusercontent.com/31485710/79466685-e6c4cd00-7fca-11ea-9bee-f56f063f5b64.png)
6. For each plugin listed under the "Updates" tab, check its check box and then click on "Download now and install after restart" (the wording will be similar, at least). (Optionally) click the "Check now" button to make sure you have the most recent list of plugins to update. You should be taken to the update center and given a status of the installs. Wait until they are all done downloading and ready for a restart. __NOTE: Take note of ANY plugins saying that they update the format of their configuration or otherwise have red notices on them. You will likely need to manually verify and correct the behavior/config of those plugins after an upgrade__
![image](https://user-images.githubusercontent.com/31485710/79466843-1d024c80-7fcb-11ea-8eef-64bfc41f8cc9.png)
![image](https://user-images.githubusercontent.com/31485710/79467256-97cb6780-7fcb-11ea-8cde-05bb098c6695.png)
7. Jenkins is notoriously bad about actually restarting after the plugins have downloaded, even if you check the option. So go to "<jenkins url>/restart" in your browser to actually force a restart.
![image](https://user-images.githubusercontent.com/31485710/79467523-d6612200-7fcb-11ea-8c0d-786e9497f3b4.png)
8. Wait for Jenkins to restart and verify under "Manage Jenkins" and "Manage Plugins" that no more updates are necessary. Jenkins will also warn you, under "Manage Jenkins" if any plugin configuration need updated due to the upgrade.

Now that the plugins and/or Jenkins are updated, we need to take note of them in source control (here) to make sure we have them in case we need to restore them. 
1. Grab a list of all the plugins we have. At present, you can't use the commands listed earlier on in this README as you need to logged in.
  a. Log in and click on "Manage Jenkins"
  b. Click on the "Script Console" button
  ![image](https://user-images.githubusercontent.com/31485710/79471820-12e34c80-7fd1-11ea-8ed5-327d891a0e39.png)
  c. Enter and run the following script to get a sorted and formatted list of all plugins:
  ```groovy
  Jenkins.instance.pluginManager.plugins.sort(false).each{
    plugin -> 
      println ("${plugin.getShortName()}:${plugin.getVersion()}")
  }
  ```
  ![image](https://user-images.githubusercontent.com/31485710/79472035-58a01500-7fd1-11ea-857d-3826dc91c4c2.png)
  d. Copy the list of plugins returned onto your clipboard
2. Paste the copied list into the `src/docker/jenkins/master/plugins.txt` file and verify that its git diff isn't too huge (if it is, it's possible you messed up)
3. Open a PR for the change and confirm that the CI build for it makes a new master docker image successfully.
4. Once you merge into master, check the CI merge build to confirm what the new master docker image tag is.
![image](https://user-images.githubusercontent.com/31485710/79472538-f5fb4900-7fd1-11ea-968c-55dda16cb44b.png)
5. In the [scos-alm](https://github.com/SmartColumbusOS/scos-alm) repository, update the docker image tag in the `jenkins.tf` file.
![image](https://user-images.githubusercontent.com/31485710/79472750-3955b780-7fd2-11ea-86e2-e576968befcd.png)
6. Put that change through a PR, merge, etc. and then `terraform` plan and apply those changes from your local workstation (they are not done by CI as they affect CI).
7. Once the `terraform` steps are done, you'll need to manually force AWS ECS to roll the master, as it won't on its own. Make sure to let people know that Jenkins is going down (you can even do a "Prepare for Shutdown" as described earlier.
  a. Go to ECS in AWS and on click on the main Jenkins cluster in the "Clusters" tab
  ![image](https://user-images.githubusercontent.com/31485710/79473153-be40d100-7fd2-11ea-8aa3-39d1ca403a27.png)
  b. Click on the "tasks" tab and the check the main master task. It will have "continuous delivery" in its name.
  ![image](https://user-images.githubusercontent.com/31485710/79473412-18da2d00-7fd3-11ea-967d-d7dc2f9fea97.png)
  c. Click on the "stop" button, and ECS will stop the container and run a new one with the latest image.
  ![image](https://user-images.githubusercontent.com/31485710/79473519-3c04dc80-7fd3-11ea-9e0d-b444356bf07c.png)
  d. After a few minutes verify that Jenkins is back up and running with no warning or errors under "Manage Jenkins"
