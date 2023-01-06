output "eks_cluster_arn" {
  value       = local.eks_cluster.arn
  description = "ARN of the cluster."
}
output "eks_cluster_certificate_authority" {
  value       = local.eks_cluster.certificate_authority
  description = "Attribute block containing certificate-authority-data for your cluster. Detailed below."
}
output "eks_cluster_created_at" {
  value       = local.eks_cluster.created_at
  description = "Unix epoch timestamp in seconds for when the cluster was created."
}
output "eks_cluster_endpoint" {
  value       = local.eks_cluster.endpoint
  description = "Endpoint for your Kubernetes API server."
}
output "eks_cluster_id" {
  value       = local.eks_cluster.id
  description = "Name of the cluster."
}
output "eks_cluster_identity" {
  value       = local.eks_cluster.identity
  description = "Attribute block containing identity provider information for your cluster. Only available on Kubernetes version 1.13 and 1.14 clusters created or upgraded on or after September 3, 2019. Detailed below."
}
output "eks_cluster_platform_version" {
  value       = local.eks_cluster.platform_version
  description = "Platform version for the cluster."
}
output "eks_cluster_status" {
  value       = local.eks_cluster.status
  description = "Status of the EKS cluster. One of CREATING, ACTIVE, DELETING, FAILED."
}
output "eks_cluster_tags_all" {
  value       = local.eks_cluster.tags_all
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}
output "eks_cluster_vpc_config" {
  value       = local.eks_cluster.vpc_config
  description = "Configuration block argument that also includes attributes for the VPC associated with your cluster. Detailed below."
}

output "cloudwatch_log_group_arn" {
  value       = aws_cloudwatch_log_group.this[0].arn
  description = "The Amazon Resource Name (ARN) specifying the log group. Any :* suffix added by the API, denoting all CloudWatch Log Streams under the CloudWatch Log Group, is removed for greater compatibility with other AWS services that do not accept the suffix."
}

output "node_group_arn" {
  value = {
    for k, v in aws_eks_node_group.this : k => v.arn
  }
  description = "Amazon Resource Name (ARN) of the EKS Node Group."
}
output "node_group_id" {
  value = {
    for k, v in aws_eks_node_group.this : k => v.id
  }
  description = "EKS Cluster name and EKS Node Group name separated by a colon (:)."
}
output "node_group_resources" {
  value = {
    for k, v in aws_eks_node_group.this : k => v.resources
  }
  description = "List of objects containing information about underlying resources."
}
output "node_group_tags_all" {
  value = {
    for k, v in aws_eks_node_group.this : k => v.tags_all
  }
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}
output "node_group_status" {
  value = {
    for k, v in aws_eks_node_group.this : k => v.status
  }
  description = "Status of the EKS Node Group."
}

output "node_group_role_arn" {
  value       = aws_iam_role.node_group[0].arn
  description = "IAM Role Arn used by node groups in the eks cluster"
}
output "global_encryption_kms_key_arn" {
  value       = aws_kms_key.this[0].arn
  description = "KMS Key arn used by node groups and the the eks cluster for encryption."
}
output "eks_cluster_name" {
  value       = local.eks_cluster.name
  description = "Name of the eks cluster"
}
output "eks_cluster_primary_security_group_id" {
  value       = local.eks_cluster.vpc_config[0].cluster_security_group_id
  description = "Primary security group id of the EKS cluster"
}
