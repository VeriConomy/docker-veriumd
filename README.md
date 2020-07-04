
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

# Where to Store Data / Managing the wallet.dat

Important note: When it comes to keeping your VRM safe, running this Docker container is no different than compiling the code or running the binary.  <b>It is critical to backup and maintain your wallet.dat and private keys!</b>

There are several ways to store data used by applications that run in Docker containers. We encourage users of the Vericonomy images to familiarize themselves with the options available, including:

Create a data directory on the host system (outside the container) and mount this to a directory visible from inside the container. This places the files in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly.

The Docker documentation is a good starting point for understanding the different storage options and variations, and there are multiple blogs and forum postings that discuss and give advice in this area. We will simply show the basic procedure here for the latter option above:

1. Create a data directory on a suitable volume on your host system, e.g. /my/own/datadir.

2. Start your mysql container like this:

```bash
      $ docker run --name super-cool-veriumd -v /my/own/datadir:/root/.verium -d vericonomy/veriumd:tag
```

The ```bash -v /my/own/datadir:/root/.verium ``` part of the command mounts the ```bash /my/own/datadir ``` directory from the underlying host system as the ```bash /root/.verium ``` folder inside the container, where Veriumd by default will write its blockchain, wallet.dat, logging and config files.

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