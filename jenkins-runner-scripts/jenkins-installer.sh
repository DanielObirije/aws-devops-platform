#!/bin/bash
sudo apt update
sudo apt install -y openjdk-17-jdk wget unzip

sudo wget -0 /usr/share/keystring/jenkins-keyring.asc \
   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
 
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
 https://pkg.jenkins.io/debian-stable binary/" | \ 
 sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update

sudo apt install -y jenkins

wget https://hashicorp.com

unzip terraform_1.15.5_linux_amd64.zip

rm terraform_1.15.5_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform --version
java -version
jenkins --version