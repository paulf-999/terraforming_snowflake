sudo apt-get update
sudo apt-get install -y wget unzip
TERRA_VERSION="1.6.5"
wget https://releases.hashicorp.com/terraform/${TERRA_VERSION}/terraform_${TERRA_VERSION}_linux_amd64.zip
unzip terraform_${TERRA_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
