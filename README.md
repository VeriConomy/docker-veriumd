
# docker-veriumd

[![Docker Stars](https://img.shields.io/docker/stars/jamesob/bitcoind.svg)](https://hub.docker.com/r/jamesob/bitcoind/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jamesob/bitcoind.svg)](https://hub.docker.com/r/jamesob/bitcoind/)

A Docker configuration with sane defaults for running a fully-validating
Verium node, based on [Ubuntu](https://ubuntu.org/).

## Quick start

Requires that [Docker be installed](https://docs.docker.com/install/) on the host machine.

```bash
# Create some directory where your Verium data will be stored.
$ mkdir /home/youruser/verium_data

$ docker run --name veriumd -d \
   --env 'BTC_RPCUSER=foo' \
   --env 'BTC_RPCPASSWORD=password' \
   --env 'BTC_TXINDEX=1' \
   --volume /home/youruser/verium_data:/root/.verium \
   --publish 9333:9333 \
   jamesob/veriumd

$ docker logs -f veriumd
[ ... ]
```


## Configuration

A custom `verium.conf` file can be placed in the mounted data directory.
Otherwise, a default `verium.conf` file will be automatically generated based
on environment variables passed to the container:

| name | default |
| ---- | ------- |
| BTC_RPCUSER | vrm |
| BTC_RPCPASSWORD | changemeplz |
| BTC_RPCPORT | 9333 |
| BTC_RPCALLOWIP | ::/0 |
| BTC_RPCCLIENTTIMEOUT | 30 |
| BTC_DISABLEWALLET | 1 |
| BTC_TXINDEX | 0 |
| BTC_TESTNET | 0 |
| BTC_DBCACHE | 0 |


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
