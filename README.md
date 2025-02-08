# Automated Deployment of Elasticsearch on AWS using Terraform and Ansible

## Overview

This automation sets up an AWS infrastructure using Terraform and deploys Elasticsearch using Ansible. The Terraform script provisions a Virtual Private Cloud (VPC), subnets, security groups, IAM roles, and an EC2 instance. Ansible then installs and configures Elasticsearch on the instance.

## Terraform Configuration

### Resources Created:

VPC and Subnets

A VPC (aws_vpc.terraform_vpc) with DNS support enabled.

A public subnet (aws_subnet.terraform_public_subnet) for hosting the EC2 instance.

A private subnet (aws_subnet.terraform_private_subnet) for internal resources.

Networking Components

An Internet Gateway (aws_internet_gateway.terraform_nebo_igw) for public internet access.

A Route Table (aws_route_table.terraform_route_table) to route external traffic.

A Route Table Association (aws_route_table_association.terraform_public_assoc) linking the public subnet to the route table.

IAM Roles and Policies

An IAM Role (aws_iam_role.ec2_role_ansi) for EC2 instances, allowing them to interact with AWS services.

An IAM Policy (aws_iam_policy.ec2_policy_ansi) granting permissions for EC2 instances to use AWS Systems Manager (SSM) and manage parameters.

A Role Policy Attachment (aws_iam_role_policy_attachment.ec2_policy_attach_ansi) associating the IAM policy with the role.

An IAM Instance Profile (aws_iam_instance_profile.ec2_instance_profile_ansi) linking the role to the EC2 instance.

Security Groups

A Security Group (aws_security_group.terraform_elastic_sg) allowing:

Port 9200 (TCP) for Elasticsearch communication.

Port 22 (TCP) for SSH access.

All outbound traffic for unrestricted egress.

EC2 Instance

An EC2 instance (aws_instance.terraform_elasticsearch) running Amazon Linux 2023.

Instance parameters:

AMI ID: var.linux_ami

Instance type: var.instance_type

Public subnet association

Security group attachment

IAM instance profile attachment

20GB root volume

SSH key: nebo_key

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

Ensure an SSH key pair (nebo_key) is available for instance access.

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
ssh -i ~/.ssh/nebo_key ec2-user@<EC2_PUBLIC_IP>
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