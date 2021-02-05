# /bin/bash

# Install rpmfusion
wget https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-33.noarch.rpm
rpm -ivh rpmfusion-free-release-33.noarch.rpm

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Generate SSH Key
ssh-keygen -f key
chown $USER:$USER key
chown $USER:$USER key.pub

# Install Git
dnf install git -y

# Install ansible and GCP (Google CLoud Platform) module
dnf install ansible -y
pip install --user requests google-auth
