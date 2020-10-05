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
# the verium source:
#   https://github.com/VeriumReserve/verium/blob/master/share/examples/verium.conf
# the wiki:
#   https://en.bitcoin.it/wiki/Running_Bitcoin

# server=1 tells verium-Qt and veriumd to accept JSON-RPC commands
server=1

# You must set rpcuser and rpcpassword to secure the JSON-RPC api
rpcuser=${VRM_RPCUSER:-vrm}
rpcpassword=${VRM_RPCPASSWORD:-changemeplz-or-you-will-have-all-your-coins-stolen}

# Need rpcbind or this little bastard won't work
rpcbind=${VRM_RPCBIND:-127.0.0.1}

#Lets allow all RPC IPs, OK?
rpcallowip=${VRM_RPCALLOWIP:-::/0}

# Listen for RPC connections on this TCP port:
rpcport=${VRM_RPCPORT:-33987}

# Listen for P2P connections on this TCP port:
port=${VRM_P2PORT:-33988}

# Print to console (stdout) so that "docker logs veriumd" prints useful
# information.
printtoconsole=${VRM_PRINTTOCONSOLE:-1}

# We probably want a wallet.
disablewallet=${VRM_DISABLEWALLET:-0}

# Enable an on-disk txn index. Allows use of getrawtransaction for txns not in
# mempool.
txindex=${VRM_TXINDEX:-0}

# Run on the test network instead of the real verium network.
testnet=${VRM_TESTNET:-0}

EOF
fi

if [ $# -eq 0 ]; then
  exec veriumd -datadir=${VERIUM_DIR} -conf=${VERIUM_CONF}
else
  exec "$@"
fi
