#!/bin/bash

# un-official strict mode
set -euo pipefail

echo "[nginx] booting container. ETCD: $ETCD."

echo "[nginx] etcd updater is now updating etcd with changes..."
etcd_updater_service.rb start

# start nginx in foreground
echo "[nginx] nginx starting..."
nginx -g "daemon off;"
