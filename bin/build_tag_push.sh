#!/bin/bash

set -exuo pipefail

TAG=${1:-latest}

docker build -t vericonomy/bitcoind:${TAG} .
docker login
docker push vericonomy/bitcoind:${TAG}
