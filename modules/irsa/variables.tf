
##########################
######## IRSA #############
#########################

variable "enable_irsa" {
  type        = bool
  description = "Whether to use IRSA for helm release deployment or not?"
  default     = true
}

variable "oidc_issuer_url" {
  type        = string
  description = "(Required)Issuer URL for the OpenID Connect identity provider."
}

variable "irsa_role_name" {
  type        = string
  description = "(optional) Role name created with the IRSA policy"
  default     = ""
}

variable "role_path" {
  type        = string
  description = "(optional)  Path to the role"
  default     = null
}

variable "force_detach_policies" {
  type        = bool
  description = "(optional) Whether to force detaching any policies the role has before destroying it, refer to [TOP NOTE Section](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) for default value."
  default     = true
}

variable "permissions_boundary" {
  type        = string
  description = "(optional) ARN of the policy that is used to set the permissions boundary for the role."
  default     = null
}

/*
  * To avoid the "Terraform cannot predict how many instances will be created error message used a map(strings) is used to create dynamic variable values.
  * key can be any human readable string to explain policy type.(technically key can be any string)
*/
variable "role_policy_arns" {
  type        = map(string)
  description = "(optional) Policies ARNs attached with the IRSA IAM role. Map where key can be any random string and value as a valid policy ARN."
  default     = {}
}

variable "use_wildcard_service_account_policy" {
  type        = bool
  description = "(optional) Whether to use the wildcard service account name or not? The created role can be used by any service account, if use_wildcard_namespace is set to false then restricts to namespace variable otherwise otherwise globally. Use it with caution !!"
  default     = false
}

variable "use_wildcard_namespace_policy" {
  type        = bool
  description = "(optional) Whether to use the wildcard namespace name or not? If set to true then created role can be used by any service account in any namespace. Use it with caution !!"
  default     = false
}

variable "aws_account_id" {
  type        = string
  description = "(optional) Account ID from where EKS cluster will assume role, could be used in cross account scenarios."
  default     = ""
}

############################################
######## Service Account variables ##########
############################################

variable "create_kubernetes_namespace" {
  type        = bool
  description = "(optional) Whether or not to create kubernetes namespace via terraform-kubernetes-provider resource? Set to true if need to create a new namespace and helm release attribute 'create_namespace' is set to false"
  default     = false
}
variable "namespace" {
  description = "(Required) The namespace where service account will be created. New will be created if value is not equeal to kube-sytem and default"
  type        = string
}

variable "namespace_labels" {
  type        = map(string)
  description = "(optional)Labels for namespace created via terraform-kubernetes-provider resource."
  default     = {}
}

variable "namespace_annotations" {
  type        = map(string)
  description = "(optional) Annotations for namespace created via terraform-kubernetes-provider resource."
  default     = {}
}

variable "create_service_account" {
  type        = bool
  description = "(optional) Whether or not to create service account for the helm release?"
  default     = false
}

variable "service_account_annotations" {
  type        = map(string)
  description = "(optional) Additional Annotations for the new service account created."
  default     = {}
}

variable "service_account_name" {
  type        = string
  description = "(Required) Service Account Name if needs to create new via terraform or from the helm chart/release created service account name for IRSA assume policy."
}

variable "automount_service_account_token" {
  type        = bool
  description = "(Optional) To enable automatic mounting of the service account token. Defaults to true"
  default     = null
}
