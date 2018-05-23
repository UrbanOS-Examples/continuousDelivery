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

