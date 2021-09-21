# ChainLink Full Node

Uses the official ChainLink [Docker images](https://hub.docker.com/r/smartcontract/chainlink) in combination with the official [Postgres images](https://hub.docker.com/_/postgres) to deploy a full node. This works on any machine that can run Docker *(Linux, macOS, Windows)*, provided the machine meets the [minimum requirements](https://docs.chain.link/docs/running-a-chainlink-node).

## Setup

### Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Configuration

Run the `configure.sh` file and follow the prompts to set up the environment.

```bash
$ bash configure.sh
```

Afterwards you can add custom configuration to the `.env` files before starting the node.

```bash
├── chainlink.env
└── postgres.env
```

### Running

Use `docker-compose` to get your full node up and running.

```bash
docker-compose up -d
```

It will take a while to start your node, but when it's finished it will be available at http://localhost:6688/
