# What is this Docker image?

The Jenkins worker image is responsible for all code CI builds excluding
jenkins itself.  A container is deployed to an Amazon ECS cluster for each
job configured to use the "infrastructure" node.  The deployment is managed
and configured with the [Amazon ECS Jenkins Plugin][amazon_ecs_plugin].  Every
tool needed to run any build within the SmartColumbusOS and Datastillery
organization is included:

  - terraform
  - helm
  - kubectl
  - elixir
  - docker-compose

# How To

## Deploy updated workers to a Jenkins cluster

Once the worker image has been updated, merged, and deployed to ECR there is
one final step to get the image into circulation.  The new image will be built
with a tag based on the git hash of the build (this can be obtained via
`git rev-parse origin/master` after a fetch).  To notify jenkins of the new
image the "[Cloud Configuration][configure_cloud]" must be updated with a the
updated Docker image tag.  Once the tag update has been applied new jobs will
immediately start using the new image


[amazon_ecs_plugin]: https://plugins.jenkins.io/amazon-ecs/
[configure_cloud]: https://jenkins.alm.internal.smartcolumbusos.com/configureClouds/