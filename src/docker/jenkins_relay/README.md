# JenkinsRelay

## Running Tests
`docker run -it --rm <image> mix test`

## Running the Application
`docker run -d -e JENKINS_HOST="localhost" -e JENKINS_PORT="8080" -e GH_WEBHOOK_SECRET="secret" --name github_jenkins_relay <image>`
