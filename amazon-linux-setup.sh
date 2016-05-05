#!/usr/bin/env bash

# Setup docker and docker-compose for Amazon Linux AMI.

sudo yum -y update

sudo yum -y install docker

# At the time, only docker version 1.9 is available in the Amazon repo.
# We need to update to version 1.10+. The command below can be remove in
# the future when a newer version is available in Amazon repo.
sudo curl -o /usr/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-1.10.3

# Start the Docker service.
sudo service docker start

# Add the ec2-user to the docker group so you can execute Docker
# commands without using sudo. Need to log out and log back in
# again to pick up the new docker group permissions.
sudo usermod -a -G docker ec2-user

# Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > docker-compose
sudo chown root docker-compose
sudo mv docker-compose /usr/local/bin
sudo chmod +x /usr/local/bin/docker-compose