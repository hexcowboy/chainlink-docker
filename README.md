# ChainLink Full Node

Uses the official ChainLink [Docker images](https://hub.docker.com/r/smartcontract/chainlink) in combination with the official [Postgres images](https://hub.docker.com/_/postgres) to deploy a full node. This works on any machine that can run Docker *(Linux, macOS, Windows)*, provided you meet the [minimum requirements](https://docs.chain.link/docs/running-a-chainlink-node).

## Setup

### Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Configuration

To configure your node, place your [environment file](https://docs.chain.link/docs/running-a-chainlink-node/#create-an-environment-file) in the `chainlink/` folder.

```bash
├── README.md # You are here
└── chainlink
    └── .env
```

**⚠️ The existing `.env` file contains information that should not be overwritten. Instead, append your configuration to the file.**

### Running

Use `docker-compose` to get your full node up and running.

```bash
docker-compose up -d
```
