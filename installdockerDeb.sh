#!/bin/bash

set -e

sleep 10

# Function for logging
log() {
    echo "$(date): $1" >> installation_log.txt
}

# Update package repository and install curl and ca-certificates
apt-get update && apt-get install ca-certificates curl -y
printf '\nCa-certificates and Curl installed successfully\n\n'
log "Updates completed. Curl installed."

# Setup Docker repository
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
printf '\nDocker repository setup\n\n'
log "Docker repository setup."  

# Update package repository and install
apt-get update && apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
printf '\nDocker and Docker Compose setup\n\n'
log "Docker and Docker Compose has been installed."

# Final message
echo "Installation completed successfully. Check installation_log.txt for details."
