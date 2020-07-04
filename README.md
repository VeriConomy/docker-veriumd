
# docker-veriumd

[![Docker Stars](https://img.shields.io/docker/stars/vericonomy/veriumd.svg)](https://hub.docker.com/r/vericonomy/veriumd/)
[![Docker Pulls](https://img.shields.io/docker/pulls/vericonomy/veriumd.svg)](https://hub.docker.com/r/vericonomy/veriumd/)

A Docker configuration with sane defaults for running a fully-validating Verium node.

## Quick start

Requires that [Docker be installed](https://docs.docker.com/install/) on the host machine.

### Clone and build the docker image

```bash
# Create some directory where your Verium data will be stored.
$ mkdir /home/youruser/verium_data

$ docker run --name veriumd -d \
   --env 'VRM_RPCUSER=foo' \
   --env 'VRM_RPCPASSWORD=password' \
   --env 'VRM_TXINDEX=1' \
   --volume /home/youruser/verium_data:/root/.verium \
   --publish 9333:9333 \
   vericonomy/veriumd

$ docker logs -f veriumd
[ ... ]
```

### Connect to the image to run a bootstrap
```bash
$ docker exec veriumd bash
```

Once logged in, navigate to the /usr/local/bin folder and run the bootstrap command

```bash
$ cd /usr/local/bin
$ ./verium-cli bootstrap

```

## Configuration

A custom `verium.conf` file can be placed in the mounted data directory.
Otherwise, a default `verium.conf` file will be automatically generated based
on environment variables passed to the container:

| name | default |
| ---- | ------- |
| VRM_RPCUSER | vrm |
| VRM_RPCPASSWORD | changemeplz |
| VRM_RPCPORT | 33987 |
| VRM_P2PORT | 33988 |
| VRM_RPCALLOWIP | ::/0 |
| VRM_RPCCLIENTTIMEOUT | 30 |
| VRM_DISABLEWALLET | 0 |
| VRM_TXINDEX | 0 |
| VRM_TESTNET | 0 |
| VRM_DBCACHE | 0 |