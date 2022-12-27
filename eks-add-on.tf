################################################################################
# EKS Addons
################################################################################
resource "aws_eks_addon" "this" {
  for_each = var.create_eks_cluster ? var.cluster_addons : {}

  cluster_name             = aws_eks_cluster.this[0].name
  addon_name               = each.key
  addon_version            = try(each.value.addon_version, null)
  preserve                 = try(each.value.preserve, null)
  resolve_conflicts        = try(each.value.resolve_conflicts, null)
  service_account_role_arn = try(each.value.service_account_role_arn, null)
  tags                     = var.tags


  depends_on = [
    aws_eks_node_group.this,
  ]

}
