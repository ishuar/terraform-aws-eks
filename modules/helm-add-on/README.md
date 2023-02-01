# Introduction
This Terraform submodule is designed to create a Helm release and an IAM role for a service account in the Terraform EKS module. The submodule uses Terraform to manage the deployment of the Helm chart and the IAM role.

## Prerequisites

Before using this submodule, you will need to have the following:

- EKS cluster deployed/running.
- Helm installed on your local machine.
- The Helm chart that you want to deploy, either stored locally or in a repository.

## Available Features

- Helm Release with all arguments available at [helm\_release Terraform resource](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)
- IAM roles For Service Account

## Usage

## Examples

- [Minimal required options]()
- [Complete]()

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_irsa"></a> [irsa](#module\_irsa) | ../irsa | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart"></a> [chart](#input\_chart) | (Required) Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if repository is specified. It is also possible to use the <repository>/<chart> format here if you are running Terraform on a system that the repository has been added to with helm repo add but this is not recommended. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Release name. | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | (Required)Issuer URL for the OpenID Connect identity provider. | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | (Required) Service Account Name if needs to create new via terraform or from the helm chart/release created service account name for IRSA assume policy. | `string` | n/a | yes |
| <a name="input_atomic"></a> [atomic](#input\_atomic) | (Optional) If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false. | `bool` | `true` | no |
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | (Optional) To enable automatic mounting of the service account token. Defaults to true | `bool` | `null` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | (optional) Account ID from where EKS cluster will assume role, could be used in cross account scenarios. | `string` | `""` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | (Optional) Specify the exact chart version to install. If this is not specified, the latest version is installed. helm\_release will not automatically grab the latest release, version must explicitly upgraded when upgrading an installed chart. | `string` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | (Optional) Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false. | `bool` | `true` | no |
| <a name="input_create_kubernetes_namespace"></a> [create\_kubernetes\_namespace](#input\_create\_kubernetes\_namespace) | (optional) Whether or not to create kubernetes namespace via terraform-kubernetes-provider resource? Set to true if need to create a new namespace and helm release attribute 'create\_namespace' is set to false | `bool` | `false` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | (Optional) Create the namespace if it does not yet exist. Defaults to false. | `bool` | `false` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | (optional) Whether or not to create service account for the helm release? | `bool` | `false` | no |
| <a name="input_dependency_update"></a> [dependency\_update](#input\_dependency\_update) | (Optional) Runs helm dependency update before installing the chart. Defaults to false. | `bool` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Set release description attibute (visible in the history). | `string` | `null` | no |
| <a name="input_devel"></a> [devel](#input\_devel) | (Optional) Use chart development versions, too. Equivalent to version '>0.0.0-0'. If version is set, this is ignored. | `string` | `null` | no |
| <a name="input_disable_openapi_validation"></a> [disable\_openapi\_validation](#input\_disable\_openapi\_validation) | (Optional) If set, the installation process will not validate rendered templates against the Kubernetes OpenAPI Schema. Defaults to false. | `bool` | `null` | no |
| <a name="input_disable_webhooks"></a> [disable\_webhooks](#input\_disable\_webhooks) | (Optional) Prevent hooks from running. Defaults to false. | `bool` | `null` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | Whether to use IRSA module for helm release deployment or not? If set to false then all IRSA module resources are disabled. | `bool` | `false` | no |
| <a name="input_enable_postrender"></a> [enable\_postrender](#input\_enable\_postrender) | (Optional) Whether or not to configure a command to run after helm renders the manifest which can alter the manifest contents? | `bool` | `false` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | (optional) Whether to force detaching any policies the role has before destroying it, refer to [TOP NOTE Section](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) for default value. | `bool` | `true` | no |
| <a name="input_force_update"></a> [force\_update](#input\_force\_update) | (Optional) Force resource update through delete/recreate if needed. Defaults to false. | `bool` | `null` | no |
| <a name="input_irsa_role_name"></a> [irsa\_role\_name](#input\_irsa\_role\_name) | (optional) Role name created with the IRSA policy | `string` | `""` | no |
| <a name="input_keyring"></a> [keyring](#input\_keyring) | (Optional) Location of public keys used for verification. Used only if verify is true. Defaults to /.gnupg/pubring.gpg in the location set by home | `string` | `null` | no |
| <a name="input_lint"></a> [lint](#input\_lint) | (Optional) Run the helm chart linter during the plan. Defaults to false. | `bool` | `true` | no |
| <a name="input_max_history"></a> [max\_history](#input\_max\_history) | (Optional) Maximum number of release versions stored per release. Defaults to 0 (no limit). | `number` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Optional) The namespace to install the release into. Defaults to default.This name is also used for creating new namespace via kubernetes-terraform-provider resource in this module when variable `create_namespace` is set to false and 'create\_kubernetes\_namespace' is set to true | `string` | `"default"` | no |
| <a name="input_namespace_annotations"></a> [namespace\_annotations](#input\_namespace\_annotations) | (optional) Annotations for namespace created via terraform-kubernetes-provider resource. | `map(string)` | `{}` | no |
| <a name="input_namespace_labels"></a> [namespace\_labels](#input\_namespace\_labels) | (optional)Labels for namespace created via terraform-kubernetes-provider resource. | `map(string)` | `{}` | no |
| <a name="input_pass_credentials"></a> [pass\_credentials](#input\_pass\_credentials) | (Optional) Pass credentials to all domains. Defaults to false. | `bool` | `null` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | (optional) ARN of the policy that is used to set the permissions boundary for the role. | `string` | `null` | no |
| <a name="input_postrender_args"></a> [postrender\_args](#input\_postrender\_args) | (optional) A list of arguments to supply to the post-renderer | `list(string)` | `[]` | no |
| <a name="input_postrender_binary_path"></a> [postrender\_binary\_path](#input\_postrender\_binary\_path) | (optional) Relative or full path to command binary.(Required) if enable\_postrender is set to true | `string` | `null` | no |
| <a name="input_recreate_pods"></a> [recreate\_pods](#input\_recreate\_pods) | (Optional) Perform pods restart during upgrade/rollback. Defaults to false. | `bool` | `null` | no |
| <a name="input_render_subchart_notes"></a> [render\_subchart\_notes](#input\_render\_subchart\_notes) | (Optional) If set, render subchart notes along with the parent. Defaults to true. | `bool` | `null` | no |
| <a name="input_replace"></a> [replace](#input\_replace) | (Optional) Re-use the given name, only if that name is a deleted release which remains in the history. This is unsafe in production. Defaults to false. | `bool` | `null` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | (Optional) Repository URL where to locate the requested chart. | `string` | `null` | no |
| <a name="input_repository_ca_file"></a> [repository\_ca\_file](#input\_repository\_ca\_file) | (Optional) The Repositories CA File. | `string` | `null` | no |
| <a name="input_repository_cert_file"></a> [repository\_cert\_file](#input\_repository\_cert\_file) | (Optional) The repositories cert file | `string` | `null` | no |
| <a name="input_repository_key_file"></a> [repository\_key\_file](#input\_repository\_key\_file) | (Optional) The repositories cert key file | `string` | `null` | no |
| <a name="input_repository_password"></a> [repository\_password](#input\_repository\_password) | (Optional) Password for HTTP basic authentication against the repository. | `string` | `null` | no |
| <a name="input_repository_username"></a> [repository\_username](#input\_repository\_username) | (Optional) Username for HTTP basic authentication against the repository. | `string` | `null` | no |
| <a name="input_reset_values"></a> [reset\_values](#input\_reset\_values) | (Optional) When upgrading, reset the values to the ones built into the chart. Defaults to false. | `bool` | `null` | no |
| <a name="input_reuse_values"></a> [reuse\_values](#input\_reuse\_values) | (Optional) When upgrading, reuse the last release's values and merge in any overrides. If 'reset\_values' is specified, this is ignored. Defaults to false. | `bool` | `null` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | (optional)  Path to the role | `string` | `null` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | (optional) Policies ARNs attached with the IRSA IAM role. Map where key can be any random string and value as a valid policy ARN. | `map(string)` | `{}` | no |
| <a name="input_service_account_annotations"></a> [service\_account\_annotations](#input\_service\_account\_annotations) | (optional) Additional Annotations for the new service account created. | `map(string)` | `{}` | no |
| <a name="input_set"></a> [set](#input\_set) | (Optional) Value block with custom values to be merged with the values yaml. | `map(string)` | `{}` | no |
| <a name="input_set_sensitive"></a> [set\_sensitive](#input\_set\_sensitive) | (Optional) Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff. | `map(string)` | `{}` | no |
| <a name="input_skip_crds"></a> [skip\_crds](#input\_skip\_crds) | (Optional) If set, no CRDs will be installed. By default, CRDs are installed if not already present. Defaults to false. | `bool` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | (Optional) Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to 300 seconds. | `number` | `200` | no |
| <a name="input_use_wildcard_namespace_policy"></a> [use\_wildcard\_namespace\_policy](#input\_use\_wildcard\_namespace\_policy) | (optional) Whether to use the wildcard namespace name or not? If set to true then created role can be used by any service account in any namespace. Use it with caution !! | `bool` | `false` | no |
| <a name="input_use_wildcard_service_account_policy"></a> [use\_wildcard\_service\_account\_policy](#input\_use\_wildcard\_service\_account\_policy) | (optional) Whether to use the wildcard service account name or not? The created role can be used by any service account, if use\_wildcard\_namespace is set to false then restricts to namespace variable otherwise otherwise globally. Use it with caution !! | `bool` | `false` | no |
| <a name="input_values"></a> [values](#input\_values) | (Optional) List of values in raw yaml to pass to helm. Values will be merged, in order, as Helm does with multiple -f options. | `list(string)` | `null` | no |
| <a name="input_verify"></a> [verify](#input\_verify) | (Optional) Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart; this must be hosted alongside the chart. For more information see the Helm Documentation. Defaults to false. | `bool` | `null` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | (Optional) Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to true. | `bool` | `true` | no |
| <a name="input_wait_for_jobs"></a> [wait\_for\_jobs](#input\_wait\_for\_jobs) | (Optional) If wait is enabled, will wait until all Jobs have been completed before marking the release as successful. It will wait for as long as timeout. Defaults to false. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metadata"></a> [metadata](#output\_metadata) | Helm Release metadata block |
| <a name="output_name"></a> [name](#output\_name) | Helm release name. |

## License

MIT License. See [LICENSE](https://github.com/ishuar/terraform-aws-eks/blob/main/LICENSE) for full details.