#!/bin/bash

# un-official strict mode
set -euo pipefail

export ETCD_PORT=${ETCD_PORT:-4001}
export HOST_IP=${HOST_IP:-172.17.42.1}
export ETCD=$HOST_IP:$ETCD_PORT
export CONFIG_REFRESH=${CONFIG_REFRESH:-300}

echo "[nginx] booting container. ETCD: $ETCD."

# Start nginx so we can generate the configs
# service nginx start

# Make initial configuration every 5 seconds until successful
# until confd -onetime -node $ETCD; do
#   echo "[nginx] waiting for confd to create initial nginx configuration."
#   sleep 5
# done

# Put a continual polling `confd` process into the background to watch
# for changes every $CONFIG_REFRESH seconds
# confd -interval $CONFIG_REFRESH -node $ETCD > /var/log/confd.log 2>&1 &
# echo "[nginx] confd is now monitoring etcd for changes..."
echo "[nginx] etcd updater is now updating etcd with changes..."
etcd_updater_service.rb start

# Start the Nginx service using the generated config
echo "[nginx] starting nginx service..."
# stop nginx started by debian so we can start here in foreground
service nginx stop
# start nginx in foreground
nginx -g "daemon off;"
