## Test optional variables feature from tf 1.3 once module is functional.
## Module Motivated from : https://github.com/terraform-aws-modules/terraform-aws-eks

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  eks_cluster                    = var.create_eks_cluster ? aws_eks_cluster.this[0] : data.aws_eks_cluster.this[0]
  create_cluster_iam_role        = var.create_eks_cluster && var.create_cluster_iam_role
  cluster_iam_role_name          = coalesce(var.cluster_iam_role_name, "${var.name}-cluster")
  cluster_role                   = try(aws_iam_role.this[0].arn, var.role_arn)
  cluster_encryption_policy_name = coalesce(var.cluster_encryption_policy_name, "${local.cluster_iam_role_name}-ClusterEncryption")
  dns_suffix                     = data.aws_partition.current.dns_suffix
  policy_arn_prefix              = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
}

################################################################################
# Cluster IAM Role
################################################################################
data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create_eks_cluster && var.create_cluster_iam_role ? 1 : 0

  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.${local.dns_suffix}"]
    }
  }
}
resource "aws_iam_role" "this" {
  count = local.create_cluster_iam_role ? 1 : 0

  name                  = local.cluster_iam_role_name
  path                  = var.cluster_iam_role_path
  description           = var.cluster_iam_role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = var.cluster_iam_role_permissions_boundary
  force_detach_policies = var.cluster_force_detach_policies

  # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/920
  # Resources running on the cluster are still generaring logs when destroying the module resources
  # which results in the log group being re-created even after Terraform destroys it. Removing the
  # ability for the cluster role to create the log group prevents this log group from being re-created
  # outside of Terraform due to services still generating logs during destroy process
  dynamic "inline_policy" {
    for_each = var.create_cloudwatch_log_group ? [1] : []
    content {
      name = local.cluster_iam_role_name

      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action   = ["logs:CreateLogGroup"]
            Effect   = "Deny"
            Resource = "*"
          },
        ]
      })
    }
  }

  tags = merge(var.tags,
    {
      eks_cluster = var.name
    }
  , var.cluster_iam_role_tags)
}

# Policies attached ref https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.create_cluster_iam_role ? toset(compact(distinct(concat([
    "${local.policy_arn_prefix}/AmazonEKSClusterPolicy",
    "${local.policy_arn_prefix}/AmazonEKSVPCResourceController",
  ], var.cluster_iam_role_additional_policies)))) : toset([])

  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

# Using separate attachment due to `The "for_each" value depends on resource attributes that cannot be determined until apply`
resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  count = local.create_cluster_iam_role && var.attach_cluster_encryption_policy && length(var.cluster_encryption_config) > 0 ? 1 : 0

  policy_arn = aws_iam_policy.cluster_encryption[0].arn
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_policy" "cluster_encryption" {
  count = local.create_cluster_iam_role && var.attach_cluster_encryption_policy && length(var.cluster_encryption_config) > 0 ? 1 : 0

  name        = local.cluster_encryption_policy_name
  description = var.cluster_encryption_policy_description
  path        = var.cluster_encryption_policy_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = try(aws_kms_key.this[0].arn, var.cluster_encryption_config.provider_key_arn)
      },
    ]
  })

  tags = merge(var.tags, var.cluster_encryption_policy_tags)
}


################################################################################
# EKS Cluster
################################################################################
data "aws_eks_cluster" "this" {
  count = var.create_eks_cluster ? 0 : 1
  name  = var.name
}

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster

#tfsec:ignore:aws-eks-encrypt-secrets ## As kms key arn can not be added to defaults variable value example is added in test case.
#tfsec:ignore:aws-eks-enable-control-plane-logging
resource "aws_eks_cluster" "this" {
  count = var.create_eks_cluster ? 1 : 0

  name                      = var.name
  role_arn                  = local.cluster_role
  version                   = var.cluster_version
  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    security_group_ids      = compact(distinct(concat(var.cluster_additional_security_group_ids)))
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  kubernetes_network_config {
    ip_family         = var.ip_family
    service_ipv4_cidr = var.service_ipv4_cidr
  }

  dynamic "encryption_config" {
    for_each = toset(var.cluster_encryption_config)

    content {
      provider {
        key_arn = try(aws_kms_key.this[0].arn, encryption_config.value.provider_key_arn)
      }
      resources = encryption_config.value.resources
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
    var.cluster_tags
  )

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  depends_on = [
    aws_iam_role_policy_attachment.this,
    aws_cloudwatch_log_group.this,
    aws_vpc_endpoint.ec2,
    aws_vpc_endpoint.elasticloadbalancing,
    aws_vpc_endpoint.ecr_api,
    aws_vpc_endpoint.ecr_dkr,
    aws_vpc_endpoint.sts,
    aws_vpc_endpoint.logs,
    aws_vpc_endpoint.s3,
  ]
}

## Configure Open-ID provider for the cluster
data "tls_certificate" "this" {
  url = var.create_eks_cluster ? aws_eks_cluster.this[0].identity[0].oidc[0].issuer : data.aws_eks_cluster.this[0].identity[0].oidc[0].issuer
}
resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.this.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.this.url
  tags = merge(
    var.tags,
    {
      "eks_cluster_name" = var.name
    },
  )
}

## EKS logging : CloudWatch log group.
resource "aws_cloudwatch_log_group" "this" {
  count = var.create_eks_cluster && var.create_cloudwatch_log_group ? 1 : 0

  name              = "/aws/eks/${var.name}/cluster"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id
  tags              = var.tags
}
