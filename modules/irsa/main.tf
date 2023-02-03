data "aws_caller_identity" "current" {}

locals {
  wildcard_service_account_namespace = var.use_wildcard_service_account_policy && var.use_wildcard_namespace_policy ? "*" : var.namespace
  oidc_issuer_url_without_http       = replace(var.oidc_issuer_url, "https://", "")
  aws_account_id                     = var.aws_account_id != "" ? var.aws_account_id : data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "irsa" {
  count = var.enable_irsa ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${local.aws_account_id}:oidc-provider/${local.oidc_issuer_url_without_http}"
      ]
    }

    dynamic "condition" {
      for_each = var.use_wildcard_service_account_policy ? [] : ["noWildcardServiceaccount"]

      content {
        test     = "StringEquals"
        variable = "${local.oidc_issuer_url_without_http}:sub"
        values = [
          "system:serviceaccount:${var.namespace}:${var.service_account_name}"
        ]
      }
    }

    dynamic "condition" {
      for_each = var.use_wildcard_service_account_policy ? ["wildcardServiceaccount"] : []

      content {
        test     = "StringLike"
        variable = "${local.oidc_issuer_url_without_http}:sub"
        values = [
          "system:serviceaccount:${local.wildcard_service_account_namespace}:*"
        ]
      }
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_url_without_http}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.enable_irsa ? 1 : 0

  name                  = var.irsa_role_name == "" ? "${var.service_account_name}-role" : var.irsa_role_name
  path                  = var.role_path
  force_detach_policies = var.force_detach_policies
  description           = "IAM role for the EKS Service Account: ${var.service_account_name}"
  assume_role_policy    = data.aws_iam_policy_document.irsa[0].json
  permissions_boundary  = var.permissions_boundary
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.enable_irsa ? var.role_policy_arns : {}

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}
