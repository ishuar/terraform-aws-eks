#  Private EKS Cluster with Private Jump Host Deployment

## Overview
This guide provides instructions for deploying an EKS private cluster with dependent network infrastructure and a private EC2 jump host that can only be accessed via the SSM Agent using Terraform. The guide covers the following steps:

- Creating a Virtual Private Cloud (VPC) - infrastructure
- Creating a Private Subnet with required routes.
- Creating a Public Subnet with required routes.
- Creating a Security Group for the Jump Host
- Launching the Jump Host EC2 Instance
- Configuring the SSM Agent on the Jump Host
- Deploying the EKS Private Cluster

## Prerequisites
Before proceeding with this guide, ensure that you have the following:

- Terraform installed on your local machine
- AWS CLI installed and configured with your AWS account credentials with the access to manage resources used in this configuration.

## Applying the Configuration

To create and update the resources defined in this Terraform configuration, run the following commands.

```bash
# clone the repository
git clone https://github.com/ishuar/terraform-eks.git

cd examples/private_cluster
terraform init
terraform plan
terraform apply
```

## Destroying Resources

To destroy the resources created by this Terraform configuration, run the following command.

```bash
terraform destroy -auto-approve # ignore "-auto-approve" if you don't want to autoapprove.
```