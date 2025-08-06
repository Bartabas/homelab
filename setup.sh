#!/bin/bash
#
# Docker and Docker Compose Installation Script for Ubuntu 24.04
# This script follows the official Docker installation guide.
#

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Starting Docker Installation ---"

# 1. Uninstall old versions
echo "--- Step 1: Uninstalling old Docker packages (if any)..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done


# 2. Set up Docker's APT repository.
echo "--- Step 2: Setting up Docker's APT repository..."
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


# 3. Install Docker Engine, CLI, and Compose plugin
echo "--- Step 3: Installing Docker packages..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# 4. Add your user to the 'docker' group to run commands without sudo
echo "--- Step 4: Adding current user ($USER) to the 'docker' group..."
sudo usermod -aG docker $USER


# 5. Final verification and completion message
echo "--- Installation Complete! ---"
echo ""
echo "-> Docker Version:"
docker --version
echo "-> Docker Compose Version:"
docker compose version
echo ""
echo "********************************************************************************"
echo "IMPORTANT: You must log out and log back in for the user group changes to take effect."
echo "After logging back in, you can run 'docker' commands without using 'sudo'."
echo "********************************************************************************"
