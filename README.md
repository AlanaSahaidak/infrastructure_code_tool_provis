# Automated Deployment of Elasticsearch on AWS using Terraform and Ansible

## Overview

This automation sets up an AWS infrastructure using Terraform and deploys Elasticsearch using Ansible. The Terraform script provisions a Virtual Private Cloud (VPC), subnets, security groups, IAM roles, and an EC2 instance. Ansible then installs and configures Elasticsearch on the instance.

## Terraform Configuration

### Resources Created:

- VPC and Subnets

- Networking Components

- IAM Roles and Policies

- Security Groups

A Security Group (aws_security_group.terraform_elastic_sg) allowing:

- EC2 Instance


## Ansible Configuration

### Playbook Overview

The Ansible playbook automates the installation and configuration of Elasticsearch on the EC2 instance.

### Tasks:

Install Java 11 (Amazon Corretto) - Required for running Elasticsearch.

Download Elasticsearch RPM Package - Retrieves the Elasticsearch package from Elastic's official repository.

Import Elasticsearch GPG Key - Ensures the package authenticity.

Install Elasticsearch - Installs Elasticsearch from the downloaded RPM package.

Modify Elasticsearch Configuration - Updates elasticsearch.yml to bind Elasticsearch to the local network.

Enable and Start Elasticsearch Service - Ensures Elasticsearch starts on boot.

## Deployment Steps

### Prerequisites

Install Terraform and Ansible on the local machine.

Configure AWS credentials for Terraform.

Ensure an SSH key pair is available for instance access.

### Steps to Deploy

Initialize Terraform
```
terraform init
```
Plan the Infrastructure
```
terraform plan
```
Apply the Configuration
```
terraform apply -auto-approve
```
Run Ansible Playbook
```
ansible-playbook -i inventory.ini playbook.yaml
```
Verification

SSH into the instance:
```
ssh -i ~/.ssh/key ec2-user@<EC2_PUBLIC_IP>
```
Check Elasticsearch status:
```
systemctl status elasticsearch
```
Verify Elasticsearch API response:
```
curl -X GET http://localhost:9200
```

## Conclusion

This automation streamlines the deployment of an Elasticsearch instance on AWS using Terraform for infrastructure provisioning and Ansible for software installation. This setup ensures a reproducible and efficient deployment process.