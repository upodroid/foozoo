#!/bin/bash
cd $WORKSPACE/terraform
dockerImage=eu.gcr.io/upodroid/foozoo
## Init 
sudo apt install unzip ruby-full -y
wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip
unzip terr*.zip
sudo mv terraform /usr/local/bin/
sleep 5
terraform --version

## Terraform
/snap/bin/gsutil cp gs://upo-scripts/terraform/terraform.json .
terraform init
terraform refresh
terraform plan
terraform apply -var gcrimage=${dockerImage}:Build-${BUILD_NUMBER} -var instancename=foozo-build-${BUILD_NUMBER} --auto-approve