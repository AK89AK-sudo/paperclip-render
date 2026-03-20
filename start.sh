#!/bin/bash
set -e

# Write master key file if env var provided
if [ -n "$PAPERCLIP_SECRETS_MASTER_KEY" ]; then
  mkdir -p /data/secrets
  echo "$PAPERCLIP_SECRETS_MASTER_KEY" > /data/secrets/master.key
fi

# Inject DATABASE_URL into config.json as database.connectionString
# (paperclipai doctor reads connectionString from config, not DATABASE_URL env var directly)
if [ -n "$DATABASE_URL" ]; then
  node -e "
    const fs = require('fs');
    const cfg = JSON.parse(fs.readFileSync('/app/config.json', 'utf8'));
    cfg.database.connectionString = process.env.DATABASE_URL;
    fs.writeFileSync('/app/config.json', JSON.stringify(cfg, null, 2));
  "
fi

exec paperclipai run \
  --config /app/config.json \
  --data-dir /data
