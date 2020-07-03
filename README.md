
# docker-veriumd

[![Docker Stars](https://img.shields.io/docker/stars/jamesob/bitcoind.svg)](https://hub.docker.com/r/jamesob/bitcoind/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jamesob/bitcoind.svg)](https://hub.docker.com/r/jamesob/bitcoind/)

A Docker configuration with sane defaults for running a fully-validating
Verium node, based on [Ubuntu](https://ubuntu.org/).

## Quick start

Requires that [Docker be installed](https://docs.docker.com/install/) on the host machine.

### Clone and build the docker image

```bash
$ mkdir veriumd
$ git clone https://github.com/TnTBass/docker-veriumd.git veriumd
$ cd veriumd
$ docker build . -t veriumd

# Create some directory where your Verium data will be stored.
$ mkdir /home/youruser/verium_data

$ docker run --name veriumd -d \
   --env 'VRM_RPCUSER=foo' \
   --env 'VRM_RPCPASSWORD=password' \
   --env 'VRM_TXINDEX=1' \
   --volume /home/youruser/verium_data:/root/.verium \
   --publish 9333:9333 \
   veriumd

$ docker logs -f veriumd
[ ... ]
```


## Configuration

A custom `verium.conf` file can be placed in the mounted data directory.
Otherwise, a default `verium.conf` file will be automatically generated based
on environment variables passed to the container:

| name | default |
| ---- | ------- |
| VRM_RPCUSER | vrm |
| VRM_RPCPASSWORD | changemeplz |
| VRM_RPCPORT | 9333 |
| VRM_RPCALLOWIP | ::/0 |
| VRM_RPCCLIENTTIMEOUT | 30 |
| VRM_DISABLEWALLET | 1 |
| VRM_TXINDEX | 0 |
| VRM_TESTNET | 0 |
| VRM_DBCACHE | 0 |


## Daemonizing

The smart thing to do if you're daemonizing is to use Docker's [builtin
restart
policies](https://docs.docker.com/config/containers/start-containers-automatically/#use-a-restart-policy),
but if you're insistent on using systemd, you could do something like

```bash
$ cat /etc/systemd/system/veriumd.service

# veriumd.service #######################################################################
[Unit]
Description=veriumd
After=docker.service
Requires=docker.service

[Service]
ExecStartPre=-/usr/bin/docker kill veriumd
ExecStartPre=-/usr/bin/docker rm veriumd
ExecStartPre=/usr/bin/docker pull jamesob/veriumd
ExecStart=/usr/bin/docker run \
    --name veriumd \
    -p 8333:8333 \
    -p 127.0.0.1:8332:8332 \
    -v /data/veriumd:/root/.verium \
    jamesob/veriumd
ExecStop=/usr/bin/docker stop veriumd
```

to ensure that veriumd continues to run.
