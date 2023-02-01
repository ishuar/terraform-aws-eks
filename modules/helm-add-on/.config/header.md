# Introduction
This Terraform submodule is designed to create a Helm release and an IAM role for a service account in the Terraform EKS module. The submodule uses Terraform to manage the deployment of the Helm chart and the IAM role.

## Prerequisites

Before using this submodule, you will need to have the following:

- EKS cluster deployed/running.
- Helm installed on your local machine.
- The Helm chart that you want to deploy, either stored locally or in a repository.


## Available Features

- Helm Release with all arguments available at [helm_release Terraform resource](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)
- IAM roles For Service Account

## Usage

## Examples

- [Minimal required options]()
- [Complete]()