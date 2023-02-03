output "service_account_name" {
  value       = try(kubernetes_service_account_v1.this[0].metadata[0].name, var.service_account_name)
  description = "Name of kubernetes Service Account"
}

output "namespace" {
  value       = try(kubernetes_namespace_v1.this[0].metadata[0].name, var.namespace)
  description = "Name of kubernetes namespace"
}

output "irsa_role_name" {
  value       = try(aws_iam_role.this[0].name, var.irsa_role_name)
  description = "IAM role for the EKS Service Account"
}
