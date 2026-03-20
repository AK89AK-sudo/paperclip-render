#!/bin/bash
set -e

# Write master key file if env var provided
if [ -n "$PAPERCLIP_SECRETS_MASTER_KEY" ]; then
  mkdir -p /data/secrets
  echo "$PAPERCLIP_SECRETS_MASTER_KEY" > /data/secrets/master.key
fi

exec paperclipai run \
  --config /app/config.json \
  --data-dir /data
