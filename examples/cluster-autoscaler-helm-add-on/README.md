# AWS EKS Cluster Autoscaler Helm Addon

## Overview

Configuration in this directory creates an AWS EKS cluster with the underlying network infrastructure. On top of that, an  EKS cluster-autoscaler is deployed which utilizes Amazon EC2 Auto Scaling Groups to manage node groups with a service account having access to AWS using AWS IAM roles.

### Resources created with this configuration

- Network Infrastrucutre and policies for Cluster Autoscaler with [dependencies.tf](dependencies.tf)
- EKS Cluster with [eks.tf](eks.tf)
- Cluster Autoscaler helm release and IRSA config with [main.tf](main.tf)


### Documentation for More Insights

- [AWS Autoscaling](https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html)
- [EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/cluster-autoscaling/)
- [Cluster Autoscaler on AWS](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md)
- [IAM Roles For Service Account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)


## Applying the Configuration

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

## Destroying Resources

To destroy the resources created by this Terraform configuration, run the following command.

```bash
terraform destroy -auto-approve # ignore "-auto-approve" if you don't want to autoapprove.
```

