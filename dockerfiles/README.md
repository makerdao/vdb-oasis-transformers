# Dockerfile

## execute
Builds an alpine image for running the vulcanizedb `execute` command against transformers in this repo.

### Build
Build from the project root directory with: `docker build -f dockerfiles/execute/Dockerfile . -t execute:latest` or use `make dockerbuild IMAGE=execute`
The following options are available at build time:
- `VDB_VERSION` - target a specific vulcanizedb branch/release to generate the binary (ex: `docker build -f dockerfiles/execute/Dockerfile --build-arg VDB_VERSION=v0.0.14-rc.1 . -t execute:latest`).
- `CONFIG_FILE` - path to desired config file for this container (ex: `docker build -f dockerfiles/execute/Dockerfile --build-arg CONFIG_FILE=path . -t execute:latest`).

### Run
Running the container requires an existing DB with which the container can interact.

The following arguments are required at runtime:

- `DATABASE_NAME`
- `DATABASE_HOSTNAME`
- `DATABASE_PORT`
- `DATABASE_USER`
- `DATABASE_PASSWORD`
- `CLIENT_IPCPATH`

#### Example

With arguments correctly populated, the following command will run the container on OS X:

```
docker run -e DATABASE_NAME=vulcanize_public -e DATABASE_HOSTNAME=host.docker.internal -e DATABASE_PORT=5432 -e DATABASE_USER=user -e DATABASE_PASSWORD=pw -e CLIENT_IPCPATH=https://mainnet.infura.io/v3/token -it execute:latest
```

#### Explanation

With the above command, we assume the host is exposing the database `vulcanize_public` on `localhost:5432` and user `user` with password `pw` has write access to that db.
We expect that we can successfully make calls against the [Ethereum JSON RPC API](https://github.com/ethereum/wiki/wiki/JSON-RPC) at `https://kovan.infura.io/v3/token`.

Note that on OS X, we use `host.docker.internal` to access `localhost`.
For execution on linux, replace instances of `host.docker.internal` with `localhost` and run with `--network="host"`.

#### Running with a geth docker container:
- On the `latest` geth release, run `docker build ./ -t geth-statediffing`
- Run the previously built docker container with the following flags:
    - Public the following ports from the geth container to the host:
          - `-p 8545:8545` //used in the rpc calls
          - `-p 8546:8546` //used in web socket subscription
          - `-p 30303:30303`
    - To have the geth process (in a container) use chaindata on your host machine, create a shared volume: `-v <path to shared volume on host>:/root/.ethereum`.
        - The host path of this volume could be one of the following if you're hoping to use chaindata from an exisiting node:
           - `~/Library/Ethereum/` on macOS
           - `~/.ethereum/` on Linux
     - Include the following geth flags:
        - `--rpc`
        - `--rpcaddr "0.0.0.0"`
        - `--ws`
        - `--wsaddr "0.0.0.0"`
        - `--statediff`
        - `--syncmode full`
        - `--statediff.watchedaddresses <contract address>`
        - `--statediff.watchedaddresses <contract address>`
    - e.g.
    ```shell script
        docker run -v </path/to/user/geth/directory>:/root/.ethereum -p 8545:8545 -p 8546:8546 -p 30303:30303 geth-statediffing
          --rpc --rpcaddr "0.0.0.0" --ws --wsaddr "0.0.0.0" --statediff --syncmode full --statediff.watchedaddresses <contract address>
          --statediff.watchedaddresses <contract address>
    ```
