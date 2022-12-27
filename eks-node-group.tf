
################################################################################
# Node Group IAM Role
################################################################################

locals {
  node_group_iam_role_name = coalesce(var.node_group_iam_role_name, "${var.name}-node-group")
  cni_policy               = var.ip_family == "ipv6" ? "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/AmazonEKS_CNI_IPv6_Policy" : "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  # policy_arn_prefix coming from cluster iam role local block 
}

data "aws_iam_policy_document" "node_group_assume_role_policy" {
  count = var.create_eks_cluster && var.create_node_group && var.create_node_group_iam_role ? 1 : 0

  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "node_group" {
  count = var.create_eks_cluster && var.create_node_group && var.create_node_group_iam_role ? 1 : 0

  name        = local.node_group_iam_role_name
  path        = var.node_group_iam_role_path
  description = var.node_group_iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.node_group_assume_role_policy[0].json
  permissions_boundary  = var.node_group_iam_role_permissions_boundary
  force_detach_policies = true

  tags = merge(var.tags, var.node_group_iam_role_tags)
}

# Policies attached ref https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
resource "aws_iam_role_policy_attachment" "node_group" {
  for_each = var.create_eks_cluster && var.create_node_group && var.create_node_group_iam_role ? toset(compact(distinct(concat([
    "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy",
    "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly",
    var.node_group_iam_role_attach_cni_policy ? local.cni_policy : "",
  ], var.node_group_iam_role_additional_policies)))) : toset([])

  policy_arn = each.value
  role       = aws_iam_role.node_group[0].name
}
################################################################################
# EKS Node group
################################################################################

locals {
  ## Add back if need to put launch template within the module 
  # launch_template_name = try(aws_launch_template.this[0].name, var.launch_template_name, null)
  # Change order to set version priority before using defaults
  # launch_template_version    = coalesce(var.launch_template_version, try(aws_launch_template.this[0].default_version, "$Default"))
  # use_custom_launch_template = var.create_launch_template || var.launch_template_name != ""
}

resource "aws_eks_node_group" "this" {
  for_each = var.create_node_group ? var.node_groups : {}

  # Required
  cluster_name  = local.eks_cluster.name
  node_role_arn = var.create_node_group_iam_role ? aws_iam_role.node_group[0].arn : each.value["node_role_arn"]
  subnet_ids    = var.subnet_ids

  # subnet_ids    = each.value["subnet_ids"]


  scaling_config {
    min_size     = each.value["min_size"]
    max_size     = each.value["max_size"]
    desired_size = each.value["desired_size"]
  }

  # Optional
  node_group_name = each.key

  # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami
  ami_type             = try(each.value["ami_type"], null)
  release_version      = try(each.value["ami_release_version"], null)
  version              = try(var.cluster_version, null)
  capacity_type        = try(each.value["capacity_type"], null)
  disk_size            = var.use_launch_template ? null : try(each.value["disk_size"], null) # if using LT, set disk size on LT or else it will error here, null)
  force_update_version = try(each.value["force_update_version"], null)
  instance_types       = try(each.value["instance_types"], null)
  labels               = try(merge({ "cluster_name" = var.name }, each.value["labels"]), null)

  dynamic "launch_template" {
    for_each = var.use_launch_template ? [1] : []
    content {
      id      = aws_launch_template.this[0].id
      version = aws_launch_template.this[0].default_version
    }
  }

  dynamic "taint" {
    for_each = try(each.value["taints"], {})
    content {
      key    = taint.value["key"]
      value  = try(taint.value["value"], null)
      effect = taint.value["effect"]
    }
  }

  dynamic "update_config" {
    for_each = try(each.value["update_config"], {})
    content {
      max_unavailable_percentage = try(update_config.value["max_unavailable_percentage"], null)
      max_unavailable            = try(update_config.value["max_unavailable"], null)
    }
  }

  timeouts {
    create = lookup(var.node_group_timeouts, "create", null)
    update = lookup(var.node_group_timeouts, "update", null)
    delete = lookup(var.node_group_timeouts, "delete", null)
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size,
    ]
  }

  tags = merge(
    var.tags,
    {
      "Name"         = each.key
      "cluster_name" = var.name
    },
    try(each.value["node_group_tags"], null)
  )
  depends_on = [
    aws_iam_role_policy_attachment.node_group,
    # aws_kms_grant.autoscaling_role_for_kms,
  ]
}
