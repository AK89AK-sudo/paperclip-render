#!/bin/bash
set -e

# Write master key file if env var provided
if [ -n "$PAPERCLIP_SECRETS_MASTER_KEY" ]; then
  mkdir -p /data/secrets
  echo "$PAPERCLIP_SECRETS_MASTER_KEY" > /data/secrets/master.key
fi

# Inject DATABASE_URL and optional PUBLIC_URL overrides into config.json
node -e "
  const fs = require('fs');
  const cfg = JSON.parse(fs.readFileSync('/app/config.json', 'utf8'));
  if (process.env.DATABASE_URL) {
    cfg.database.connectionString = process.env.DATABASE_URL;
  }
  if (process.env.PAPERCLIP_PUBLIC_URL) {
    cfg.auth.publicBaseUrl = process.env.PAPERCLIP_PUBLIC_URL;
  }
  fs.writeFileSync('/app/config.json', JSON.stringify(cfg, null, 2));
"

exec paperclipai run \
  --config /app/config.json \
  --data-dir /data
