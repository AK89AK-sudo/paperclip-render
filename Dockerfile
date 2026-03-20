FROM node:20-slim

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install paperclipai globally
RUN npm install -g paperclipai@2026.318.0

# Create required directories
RUN mkdir -p /data/logs /data/storage /data/secrets

# Copy config and startup script
COPY config.json /app/config.json
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 3100

CMD ["/app/start.sh"]
