#!/bin/bash
# Used via cloud-init in terraform/modules/digitalocean_droplet/main.tf
# Logs can be found at /var/log/cloud-init-output.log

# Update packages, and install fail2ban
echo "UPDATING PACKAGES"
apt-get update -y
# TODO: investigate getting through post upgrade interactivity from ssh-server.
# apt-get upgrade -y

echo "INSTALLING FAIL2BAN"
apt-get install fail2ban -y

# Create rink and deploy user, then add them to sudo without requiring password. 
# Flags will disable password and iteractive form
echo "ADDING USERS"
adduser --disabled-password --gecos "" rink
adduser --disabled-password --gecos "" deploy
usermod -aG sudo rink
usermod -aG sudo deploy
echo 'rink ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
echo 'deploy ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# Copy over ssh keys
echo "COPYING KEYS"
install -d -m 0700 -o rink -g rink /home/rink/.ssh
head -1 /root/.ssh/authorized_keys >> /home/rink/.ssh/authorized_keys
install -d -m 0700 -o deploy -g deploy /home/deploy/.ssh
tail -1 /root/.ssh/authorized_keys >> /home/deploy/.ssh/authorized_keys

# Disable Root login
echo "UPDATING SSH SERVICE"
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
service ssh restart

# Add 3GB Swap
echo "ADD SWAP"
fallocate -l 3G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Download Dokku
echo "INSTALLING DOKKU"
wget -NP . https://dokku.com/install/v0.31.5/bootstrap.sh
sudo DOKKU_TAG=v0.31.5 bash bootstrap.sh

# Setup Dokku
echo "SETTING UP DOKKU"
cat /home/deploy/.ssh/authorized_keys | dokku ssh-keys:add admin
dokku domains:set-global rink-sync.jackrothrock.com

# Configure Dokku
echo "CONFIGURING DOKKU"
dokku apps:create rink-sync
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku plugin:install https://github.com/dokku/dokku-redis.git redis

echo "CONFIGURING POSTGRES"
dokku postgres:create rink_sync_production
dokku postgres:link rink_sync_production rink-sync

echo "CONFIGURING REDIS"
dokku redis:create rink_sync_redis_production
dokku redis:link rink_sync_redis_production rink-sync

echo "UPDATE NGINX PORT LISTENER"
dokku ports:add rink-sync http:80:3000

echo "SETTING SECRET KEY BASE"
echo $(openssl rand -base64 24) >> .secret_key_base
dokku config:set rink-sync SECRET_KEY_BASE=$(cat .secret_key_base)