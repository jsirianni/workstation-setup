#!/usr/bin/env bash

set -e

if (( EUID == 0 )); then
   echo "You must not be root" 1>&2
   exit 1
fi

# docker on centos is broken right now, installs fine when we ignore warnings
sudo dnf upgrade -y --skip-broken --nobest

sudo dnf install -y epel-release
sudo dnf install -y \
  htop \
  vim \
  nmap \
  git \
  curl \
  wget \
  unzip \
  zip

sudo dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce-3:18.09.1-3.el7
sudo systemctl enable docker && sudo systemctl start docker

wget https://atom.io/download/rpm
sudo dnf install -y rpm && rm -f rpm

wget https://dl.google.com/go/go1.13.6.linux-amd64.tar.gz && \
tar -xvf go1.13.6.linux-amd64.tar.gz && rm -f go1.13.6.linux-amd64.tar.gz && \
ls /usr/bin/go > /dev/null || sudo mv go /usr/bin/ && \
cat ~/.bashrc | grep '/usr/bin/go' || echo "export PATH=\$PATH:$(pwd)" >> ~/.bashrc

wget https://releases.hashicorp.com/vault/1.3.1/vault_1.3.1_linux_amd64.zip && \
unzip vault_1.3.1_linux_amd64.zip && rm -f vault_1.3.1_linux_amd64.zip && \
chmod +x vault && sudo mv vault /usr/local/bin

wget https://releases.hashicorp.com/terraform/0.12.19/terraform_0.12.19_linux_amd64.zip && \
unzip terraform_0.12.19_linux_amd64.zip && rm -f terraform_0.12.19_linux_amd64.zip && \
chmod +x terraform && sudo mv terraform /usr/local/bin

wget https://github.com/GoogleContainerTools/skaffold/releases/download/v1.1.0/skaffold-linux-amd64 && \
chmod +x skaffold-linux-amd64 && sudo mv skaffold-linux-amd64 /usr/local/bin/skaffold
