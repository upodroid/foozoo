#!/bin/bash
dockerImage=eu.gcr.io/upodroid/python-server
cd $WORKSPACE/terraform
## Init 
sudo apt install unzip ruby-full -y
wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.11_linux_amd64.zip
unzip terr*.zip
sudo mv terraform /usr/local/bin/
sleep 5
terraform --version

## Terraform
/snap/bin/gsutil cp gs://upo-scripts/terraform/terraform.json .
terraform init
terraform refresh
terraform plan
terraform apply -var gcrimage=${dockerImage}:Build-${BUILD_NUMBER} -var instancename=python-web-build-${BUILD_NUMBER} --auto-approve