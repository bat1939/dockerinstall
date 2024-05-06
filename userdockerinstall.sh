#!/bin/bash

set -e

sleep 10

# Function for logging
log() {
    echo "$(date): $1" >> installation_log.txt
}

# Display message install curl
echo "First, we will run updates and install sudo."
log "Running updates and installing sudo."

# Update package repository and install sudo and create a new user
apt update && apt install sudo -y
printf '\nSudo installed successfully\n\n'
log "Sudo installed."

# Create a New User
read -p "Enter the username for the new user: " new_username
read -s -p "Enter the password for the new user: " new_password
echo
read -s -p "Confirm password: " confirm_password
echo
# Check to see if passwords match
while [ "$new_password" != "$confirm_password" ]
do
    echo "Passwords do not match. Please try again."
    read -s -p "Enter the password for the new user: " new_password
    echo
    read  -s -p "Confirm password: " confirm_password
done
useradd -m -s /bin/bash "$new_username"
echo "$new_username:$new_password" | chpasswd
usermod -aG sudo "$new_username"
printf '\nNew user created and added to sudoers group\n\n'
echo "You can now log in with the username $new_username instead of root"


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
echo ""
echo "Network IP Information:"
ip a
echo ""
echo "Non-sudo user PUID and PGID: "
id $new_username
log "Installation completed successfully."
