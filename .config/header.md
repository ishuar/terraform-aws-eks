# Introduction

Welcome to the Terraform EKS Module!

Terraform module which creates AWS EKS (Kubernetes) resources. This module makes it easy to create and manage an EKS cluster on AWS, including all necessary resources such as VPC, subnets, and worker nodes. The example directory shows how to use the module in a real-world scenario.This module is versioned following semantic versioning. We would love to hear your feedback and see how you're using the module. Please feel free to open an issue on this sitory if you have any questions or suggestions.

> :star: This module is motivated from [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks) :star:

## Background Knowledge or External Documentation

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)


## Available Features

- AWS EKS Cluster Addons
- AWS EKS Identity Provider Configuration
- Support for Eks Node groups with Launch Templates
- Global KMS Key Creation for cluster secrets and Node groups EBS volumes.
- VPC Endpoints Creation in case of Private clusters.

## Usage

```hcl
module "eks" {
  source  = "ishuar/eks/aws"
  version = "~> 1.0"

  name                                  = "my-cluster"
  create_eks_cluster                    = true
  create_cluster_iam_role               = true
  attach_cluster_encryption_policy      = true
  create_cloudwatch_log_group           = true
  cluster_iam_role_name                 = "my-cluster-role"
  subnet_ids                            = ["subnet-abcde012", "subnet-bcde012a"]
  vpc_id                                = "vpc-1234556abcdef"
  cluster_additional_security_group_ids = [sg-123456abcdefg]

  ## Create Global KMS key for node and EKS cluster encryption.
  create_encryption_kms_key = true

  ## Encryption Config to encrpt secrets for Cluster using Global KMS key created within the module.
  cluster_encryption_config = [
    {
      resources = ["secrets"]
    }
  ]

  # Node groups Config.
  create_node_group          = true
  create_node_group_iam_role = true
  use_launch_template        = true
  node_group_iam_role_name   = "my-nodegroup-role"
  ebs_optimized              = true
  enable_monitoring          = false

  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        encrypted             = true
        delete_on_termination = true
        volume_size           = 80
        volume_type           = "gp3"
      }
    }
  }
  node_groups = {
    node_group_001 = {
      min_size       = 0
      max_size       = 2
      desired_size   = 1
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Examples

- [Complete Private Cluster](https://github.com/ishuar/terraform-eks/tree/main/examples/private_cluster) Cluster using private endpoint with private node groups , only accessible via private ec2 instance managed with SSM.
- [AWS ALB Controller and External DNS with EKS](https://github.com/ishuar/terraform-eks/tree/main/examples/cluster_with_alb) Real world example for How to deploy AWS ALB controller and External DNS add ons in EKS with documentation.
- [AWS EKS Cluster Autoscaler as Helm Add-on](https://github.com/ishuar/terraform-aws-eks/tree/main/examples/cluster-autoscaler-helm-add-on) demonstrate How to deploy AWS EKS cluster Autoscaler as helm addon using  [ishuar/terraform-aws-eks](https://github.com/ishuar/terraform-aws-eks) `helm-add-on` and `irsa` submodules.

## Submodules

- [`helm-add-on`](https://github.com/ishuar/terraform-aws-eks/tree/main/modules/helm-add-on)
- [`irsa`](https://github.com/ishuar/terraform-aws-eks/tree/main/modules/irsa)
