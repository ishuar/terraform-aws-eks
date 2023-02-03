############################################
######## Helm Release variables #############
############################################

variable "name" {
  description = "(Required) Release name."
  type        = string
}

variable "chart" {
  description = "(Required) Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if repository is specified. It is also possible to use the <repository>/<chart> format here if you are running Terraform on a system that the repository has been added to with helm repo add but this is not recommended."
  type        = string
}

variable "repository" {
  description = "(Optional) Repository URL where to locate the requested chart."
  type        = string
  default     = null
}

variable "repository_key_file" {
  description = "(Optional) The repositories cert key file"
  type        = string
  default     = null
  sensitive   = true
}

variable "repository_cert_file" {
  description = "(Optional) The repositories cert file"
  type        = string
  default     = null
  sensitive   = true

}

variable "repository_ca_file" {
  description = "(Optional) The Repositories CA File."
  type        = string
  default     = null
  sensitive   = true
}

variable "repository_username" {
  description = "(Optional) Username for HTTP basic authentication against the repository."
  type        = string
  default     = null
}

variable "repository_password" {
  description = "(Optional) Password for HTTP basic authentication against the repository."
  type        = string
  sensitive   = true
  default     = null
}

variable "devel" {
  description = "(Optional) Use chart development versions, too. Equivalent to version '>0.0.0-0'. If version is set, this is ignored."
  type        = string
  default     = null
}

variable "chart_version" {
  description = "(Optional) Specify the exact chart version to install. If this is not specified, the latest version is installed. helm_release will not automatically grab the latest release, version must explicitly upgraded when upgrading an installed chart."
  type        = string
  default     = null
}

variable "namespace" {
  description = "(Optional) The namespace to install the release into. Defaults to default.This name is also used for creating new namespace via kubernetes-terraform-provider resource in this module when variable `create_namespace` is set to false and 'create_kubernetes_namespace' is set to true"
  type        = string
  default     = "default"
}

variable "verify" {
  description = "(Optional) Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart; this must be hosted alongside the chart. For more information see the Helm Documentation. Defaults to false."
  type        = bool
  default     = null
}

variable "keyring" {
  description = "(Optional) Location of public keys used for verification. Used only if verify is true. Defaults to /.gnupg/pubring.gpg in the location set by home"
  type        = string
  default     = null
}

variable "timeout" {
  description = "(Optional) Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to 300 seconds."
  type        = number
  default     = 200
}

variable "disable_webhooks" {
  description = "(Optional) Prevent hooks from running. Defaults to false."
  type        = bool
  default     = null
}

variable "reuse_values" {
  description = "(Optional) When upgrading, reuse the last release's values and merge in any overrides. If 'reset_values' is specified, this is ignored. Defaults to false."
  type        = bool
  default     = null
}

variable "reset_values" {
  description = "(Optional) When upgrading, reset the values to the ones built into the chart. Defaults to false."
  type        = bool
  default     = null
}

variable "force_update" {
  description = "(Optional) Force resource update through delete/recreate if needed. Defaults to false."
  type        = bool
  default     = null
}

variable "recreate_pods" {
  description = "(Optional) Perform pods restart during upgrade/rollback. Defaults to false."
  type        = bool
  default     = null
}

variable "cleanup_on_fail" {
  description = "(Optional) Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false."
  type        = bool
  default     = true
}

variable "max_history" {
  description = "(Optional) Maximum number of release versions stored per release. Defaults to 0 (no limit)."
  type        = number
  default     = null
}

variable "atomic" {
  description = "(Optional) If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false."
  type        = bool
  default     = true
}

variable "skip_crds" {
  description = "(Optional) If set, no CRDs will be installed. By default, CRDs are installed if not already present. Defaults to false."
  type        = bool
  default     = null
}

variable "render_subchart_notes" {
  description = "(Optional) If set, render subchart notes along with the parent. Defaults to true."
  type        = bool
  default     = null
}

variable "disable_openapi_validation" {
  description = "(Optional) If set, the installation process will not validate rendered templates against the Kubernetes OpenAPI Schema. Defaults to false."
  type        = bool
  default     = null
}

variable "wait" {
  description = "(Optional) Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to true."
  type        = bool
  default     = true
}

variable "wait_for_jobs" {
  description = "(Optional) If wait is enabled, will wait until all Jobs have been completed before marking the release as successful. It will wait for as long as timeout. Defaults to false."
  type        = bool
  default     = null
}

variable "values" {
  description = "(Optional) List of values in raw yaml to pass to helm. Values will be merged, in order, as Helm does with multiple -f options."
  type        = list(string)
  default     = null
}

variable "set" {
  description = "(Optional) Value block with custom values to be merged with the values yaml."
  type        = map(string)
  default     = {}
}

variable "set_sensitive" {
  description = "(Optional) Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff."
  type        = map(string)
  default     = {}
}

variable "dependency_update" {
  description = "(Optional) Runs helm dependency update before installing the chart. Defaults to false."
  type        = bool
  default     = null
}

variable "replace" {
  description = "(Optional) Re-use the given name, only if that name is a deleted release which remains in the history. This is unsafe in production. Defaults to false."
  type        = bool
  default     = null
}

variable "description" {
  type        = string
  description = "(Optional) Set release description attibute (visible in the history)."
  default     = null
}

variable "enable_postrender" {
  description = "(Optional) Whether or not to configure a command to run after helm renders the manifest which can alter the manifest contents?"
  type        = bool
  default     = false
}

variable "postrender_binary_path" {
  type        = string
  description = "(optional) Relative or full path to command binary.(Required) if enable_postrender is set to true"
  default     = null
}

variable "postrender_args" {
  type        = list(string)
  description = "(optional) A list of arguments to supply to the post-renderer"
  default     = []
}

variable "pass_credentials" {
  description = "(Optional) Pass credentials to all domains. Defaults to false."
  type        = bool
  default     = null
}

variable "lint" {
  description = "(Optional) Run the helm chart linter during the plan. Defaults to false."
  type        = bool
  default     = true
}

variable "create_namespace" {
  description = "(Optional) Create the namespace if it does not yet exist. Defaults to false."
  type        = bool
  default     = false
}

##########################
######## IRSA #############
#########################

variable "enable_irsa" {
  type        = bool
  description = "(optional) Whether to use IRSA module for helm release deployment or not? If set to false then all IRSA module resources are disabled."
  default     = false
}

variable "oidc_issuer_url" {
  type        = string
  description = "(optional) **Required if enable_irsa is set to true.**. Issuer URL for the OpenID Connect identity provider."
  default     = ""
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

variable "create_kubernetes_namespace" {
  type        = bool
  description = "(optional) Whether or not to create kubernetes namespace via terraform-kubernetes-provider resource? Set to true if need to create a new namespace and helm release attribute 'create_namespace' is set to false"
  default     = false
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
  description = "(optional) **Required if enable_irsa is set to true.** .Service Account Name used when created via terraform or from the helm chart/release created service account name for IRSA assume policy."
  default     = ""
}

variable "automount_service_account_token" {
  type        = bool
  description = "(Optional) To enable automatic mounting of the service account token. Defaults to true"
  default     = null
}
