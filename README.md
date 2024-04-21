# First Hatchet Scraper

## Notes
### Steps
[reference](https://docs.hatchet.run/self-hosting/docker-compose)
- clone template at [link](https://github.com/hatchet-dev/hatchet-python-quickstart)
- create `.env.server`
- `docker compose up`
- login at [http://localhost:8080](http://localhost:8080)
  ```
  Email: admin@example.com
  Password: Admin123!!
  ```
- General | Create API Token - enter "First Token"
- Enter API Token in `.env.server`
  ```
  HATCHET_CLIENT_TOKEN="<token>"
  HATCHET_CLIENT_TLS_STRATEGY=none
  ```
- Install dependencies
  ```
  cd simple-examples
  poetry lock
  poetry install
  ```
- [Kubernetes Deployment](https://docs.hatchet.run/self-hosting/kubernetes)
  - `minikube start`
  - "Generate encryption keys"
    - Run in Git Bash
      ```
      # Define an alias for generating random strings. This needs to be a function in a script.
      randstring() {
          openssl rand -base64 69 | tr -d "\n=+/" | cut -c1-$1
      }
      
      # Create keys directory
      mkdir -p ./keys
      ```
    - Run in Powershell
      ```powershell
      docker pull ghcr.io/hatchet-dev/hatchet/hatchet-admin:v0.21.2
      docker run -v C:\Users\Timot\keys:/hatchet/keys ghcr.io/hatchet-dev/hatchet/hatchet-admin:v0.11.3 /hatchet/hatchet-admin keyset create-local-keys --key-dir /hatchet/keys
      ```
    - Run in Git bash
      ```
      $ # Read keysets from files
      SERVER_ENCRYPTION_MASTER_KEYSET=$(<./keys/master.key)
      SERVER_ENCRYPTION_JWT_PRIVATE_KEYSET=$(<./keys/private_ec256.key)
      SERVER_ENCRYPTION_JWT_PUBLIC_KEYSET=$(<./keys/public_ec256.key)

      # Generate the random strings for SERVER_AUTH_COOKIE_SECRETS
      SERVER_AUTH_COOKIE_SECRET1=$(randstring 16)
      SERVER_AUTH_COOKIE_SECRET2=$(randstring 16)
      ```
    - copy "hatchet-values.yaml" file over to directory
  - Deploy Hatchet by running helm commands
    - Run PowerShell
        ```
        helm repo add hatchet https://hatchet-dev.github.io/hatchet-charts
        helm install hatchet-stack hatchet/hatchet-stack --values hatchet-values.yaml --set api.replicaCount=0 --set engine.replicaCount=0 --set caddy.enabled=true
        helm upgrade hatchet-stack hatchet/hatchet-stack --values hatchet-values.yaml --set caddy.enabled=true
        ```
        - NOTE: Delete using following commands
          ```
          kubectl delete --all deployments
          kubectl delete job hatchet-stack-api-migration
          helm delete hatchet-stack
          ```
  - STUCK - unable to connect to localhost:8080 frontend even after forwarding connection. I believe engine and stack-api are not running
    ```
    PS C:\Users\Timot\Documents\GitHub\first-hatchet-scraper> kubectl get deployments
    NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
    caddy                    1/1     1            1           11m
    hatchet-engine           0/0     0            0           11m
    hatchet-stack-api        0/0     0            0           11m
    hatchet-stack-frontend   1/1     1            1           11m
    ```

<details>
<summary>Docker</summary>

- `docker compose up`
- Fix postgres
  ```
  docker container ls
  docker exec <postgres_container_id> -it shell
  ls /usr/lib/postgresql/15/bin  # verify psql is installed
  pg_lsclusters                  # verify no clusters have been created
  sudo postgres
  pg_createcluster --start 15 main
  ```
- STUCK - Docker Desktop on Windows unable to resolve DNS for Hatchet Engine
</details>

<details>
<summary>Hatchet README</summary>

## Hatchet Python Quickstart

The following is a template repo to get started with the Hatchet Python SDK. It includes instructions for getting started with Hatchet cloud along with a locally running instance of Hatchet.

### Cloud Version

Navigate to your settings tab in the Hatchet dashboard. You should see a section called "API Keys". Click "Create API Key", input a name for the key and copy the key. Then copy the environment variable:

```
HATCHET_CLIENT_TOKEN="<token>"
```

You will need this in the examples.

**Next steps:** see [Running Workflows](#running-workflows) to trigger your first Hatchet workflow.

### Local Version

Run the following command to start the Hatchet instance:

```
docker compose up
```

This will start a Hatchet instance on port `8080`. You should be able to navigate to [localhost:8080](localhost:8080) and use the following credentials to log in:

```
Email: admin@example.com
Password: Admin123!!
```

Next, navigate to your settings tab in the Hatchet dashboard. You should see a section called "API Keys". Click "Create API Key", input a name for the key and copy the key. Then copy the environment variable:

```
HATCHET_CLIENT_TOKEN="<token>"
```

You will need this in the examples.

**Next steps:** see [Running Workflows](#running-workflows) to trigger your first Hatchet workflow.

## Running Workflows

This repository includes two example projects:

1. [fast-api and react](/fast-api-react): a full stack demo OpenAi chat application
2. [simple-examples](/simple-examples): stand-alone workers showing off core functionality of hatchet

To get started, navigate to the respective example directories for further README instructions and refer to the [Documentation](https://docs.hatchet.run/home/python-sdk/setup)


</details>