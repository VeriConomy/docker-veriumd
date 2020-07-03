#!/bin/bash

set -euo pipefail

VERIUM_DIR=/root/.verium
VERIUM_CONF=${VERIUM_DIR}/verium.conf

# If config doesn't exist, initialize with sane defaults for running a
# non-mining node.

if [ ! -e "${VERIUM_CONF}" ]; then
  tee -a >${VERIUM_CONF} <<EOF

# For documentation on the config file, see
#
# the bitcoin source:
#   https://github.com/bitcoin/bitcoin/blob/master/share/examples/bitcoin.conf
# the wiki:
#   https://en.bitcoin.it/wiki/Running_Bitcoin

# server=1 tells verium-Qt and veriumd to accept JSON-RPC commands
server=1

# You must set rpcuser and rpcpassword to secure the JSON-RPC api
rpcuser=${VRM_RPCUSER:-btc}
rpcpassword=${VRM_RPCPASSWORD:-changemeplz}

# How many seconds verium will wait for a complete RPC HTTP request.
# after the HTTP connection is established.
rpcclienttimeout=${VRM_RPCCLIENTTIMEOUT:-30}

rpcallowip=${VRM_RPCALLOWIP:-::/0}

# Listen for RPC connections on this TCP port:
rpcport=${VRM_RPCPORT:-8332}

# Print to console (stdout) so that "docker logs veriumd" prints useful
# information.
printtoconsole=${VRM_PRINTTOCONSOLE:-1}

# We probably don't want a wallet.
disablewallet=${VRM_DISABLEWALLET:-1}

# Enable an on-disk txn index. Allows use of getrawtransaction for txns not in
# mempool.
txindex=${VRM_TXINDEX:-0}

# Run on the test network instead of the real verium network.
testnet=${VRM_TESTNET:-0}

# Set database cache size in MiB
dbcache=${VRM_DBCACHE:-512}

EOF
fi

if [ $# -eq 0 ]; then
  exec veriumd -datadir=${VERIUM_DIR} -conf=${VERIUM_CONF}
else
  exec "$@"
fi
