# Jenkins

We're using JNLP workers that are spun up on demand by the [Amazon EC2 Service Plugin](https://github.com/jenkinsci/amazon-ecs-plugin).
The worker docker image is capable of building and running peer docker containers.
Their purpose is to build and run images provided by our microservices.
Microservices are responsible for providing their own containerized build environment.

The first time Jenkins master is brought online, you must navigate to ${jenkins_url}/configure
and provide an access key for the cluster, as well as the cluster arn to the plugin.

## Testing Locally

To test the worker image:

- Bring up jenkins master

    ```bash
    docker compose up -d jenkins
    ```

- Sign up and create an account
- Go to http://localhost:8080/computer/new and create a new worker node.
- Once created, navigate back to the node and obtain the secret.
- Update the .env file in this directory with the worker name and secret.
- Bring up the worker image

    ```bash
    docker-compose up -d worker
    ```

- Run the `worker_test` job to verify worker image.

