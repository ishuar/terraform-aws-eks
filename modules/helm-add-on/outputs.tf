output "metadata" {
  value       = helm_release.this.metadata
  description = "Helm Release metadata block"
}

output "name" {
  value       = helm_release.this.name
  description = "Helm release name."
}
