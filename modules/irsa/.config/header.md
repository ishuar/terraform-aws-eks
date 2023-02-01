# Introduction

IRSA stands for IAM Roles for Service Accounts. It provides the ability to manage credentials for your applications, similar to the way that AmazonEC2 instance profiles provide credentials to Amazon EC2 instances. Instead of creating and distributing your AWS credentialsto the containers or using the Amazon EC2 instance's role, you associate an IAM role with a Kubernetes service account andconfigure your pods to use the service account. You can't use IAM roles for service accounts with local clusters for AmazonEKS on AWS Outposts.

AWS Official Documentation on [IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)

## Prerequisites

Before using this submodule, you will need to have the following:

- EKS cluster deployed/running.

## Available Features

- Can create a new kubernetes service account.
- Can create a new kubernetes namespace.
- Can create a role with Assumable policy by the kubernetes service account in the respective EKS cluster.
- Attach input `role_policy_arns` with the Role for Kubernetes Service Account.
- Wildcard Service Account and Wildcard Namespace assumable policies. (:warning: Use With Caution :warning:)

## Usage

### Examples
- [Minimal required options][examples]
- [Complete options][examples]

[examples]: ../../examples/irsa/main.tf