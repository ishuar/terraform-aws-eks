
locals {
  create_global_eks_kms_key        = var.create_node_group && var.create_launch_template && var.use_launch_template && var.create_encryption_kms_key
  aws_autoscaling_service_role_arn = var.create_autoscaling_service_role ? aws_iam_service_linked_role.autoscaling[0].arn : data.aws_iam_role.autoscaling[0].arn
}

# crete kms key for encryption of AWS resources
resource "aws_kms_key" "this" {
  count = local.create_global_eks_kms_key ? 1 : 0

  description              = "KMS key for the EKS cluster: ${var.name} secret encryption and cluster's node group's EC2 instance's EBS encryption."
  deletion_window_in_days  = var.deletion_window_in_days
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  enable_key_rotation      = true # key rotation should happen every year
  is_enabled               = true
  tags                     = var.tags
  policy                   = data.aws_iam_policy_document.autoscaling[0].json
}

# adding alias for the key
resource "aws_kms_alias" "this" {
  count = local.create_global_eks_kms_key ? 1 : 0

  name          = "alias/kms-${var.name}"
  target_key_id = aws_kms_key.this[0].key_id
}

## If the AWSServiceRoleForAutoScaling is not created already in the account.
resource "aws_iam_service_linked_role" "autoscaling" {
  count = local.create_global_eks_kms_key && var.create_autoscaling_service_role ? 1 : 0

  aws_service_name = "autoscaling.amazonaws.com"
  description      = "Default Service-Linked Role enables access to AWS Services and Resources used or managed by Auto Scaling"
}

data "aws_iam_role" "autoscaling" {
  count = local.create_global_eks_kms_key && !var.create_autoscaling_service_role ? 1 : 0

  name = "AWSServiceRoleForAutoScaling"
}

## Allow Autoscaling group service to use KMS key for encrypting EBS volume.
resource "aws_kms_grant" "autoscaling_role_for_kms" {
  count = local.create_global_eks_kms_key ? 1 : 0

  name              = "autoscaling-service-can-use-${var.name}-kms-key"
  key_id            = aws_kms_key.this[0].arn
  grantee_principal = local.aws_autoscaling_service_role_arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey", "DescribeKey", "ReEncryptFrom", "ReEncryptTo"]

}

data "aws_iam_policy_document" "autoscaling" {
  count = local.create_global_eks_kms_key ? 1 : 0


  version = "2012-10-17"

  ## Default KMS key policy
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  ## Allow Autoscaler service to use this kms key
  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [local.aws_autoscaling_service_role_arn]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Allow using grants of the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [local.aws_autoscaling_service_role_arn]
    }
    actions = [
      "kms:ListGrants",
      "kms:RevokeGrant",
      "kms:CreateGrant",
    ]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
    resources = ["*"]
  }

}
