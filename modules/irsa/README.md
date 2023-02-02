# Introduction

IRSA stands for IAM Roles for Service Accounts. It provides the ability to manage credentials for your applications, similar to the way that AmazonEC2 instance profiles provide credentials to Amazon EC2 instances. Instead of creating and distributing your AWS credentialsto the containers or using the Amazon EC2 instance's role, you associate an IAM role with a Kubernetes service account andconfigure your pods to use the service account. You can't use IAM roles for service accounts with local clusters for AmazonEKS on AWS Outposts.

AWS Official Documentation on [IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)

## Prerequisites

Before using this submodule, you will need to have the following:

- EKS cluster deployed/running.

## Available Features

- Can create a new kubernetes service account.
- Can create a new kubernetes namespace.
- Can create a role with Assumable policy by the kubernetes service account in the respective EKS cluster.
- Attach input `role_policy_arns` with the Role for Kubernetes Service Account.
- Wildcard Service Account and Wildcard Namespace assumable policies. (:warning: Use With Caution :warning:)

## Usage

### Examples
- [Minimal required options](../../examples/irsa/main.tf)
- [Complete options](../../examples/irsa/main.tf)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_service_account_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Required) The namespace where service account will be created. New will be created if value is not equeal to kube-sytem and default | `string` | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | (Required)Issuer URL for the OpenID Connect identity provider. | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | (Required) Service Account Name if needs to create new via terraform or from the helm chart/release created service account name for IRSA assume policy. | `string` | n/a | yes |
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | (Optional) To enable automatic mounting of the service account token. Defaults to true | `bool` | `null` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | (optional) Account ID from where EKS cluster will assume role, could be used in cross account scenarios. | `string` | `""` | no |
| <a name="input_create_kubernetes_namespace"></a> [create\_kubernetes\_namespace](#input\_create\_kubernetes\_namespace) | (optional) Whether or not to create kubernetes namespace via terraform-kubernetes-provider resource? Set to true if need to create a new namespace and helm release attribute 'create\_namespace' is set to false | `bool` | `false` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | (optional) Whether or not to create service account for the helm release? | `bool` | `false` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | Whether to use IRSA for helm release deployment or not? | `bool` | `true` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | (optional) Whether to force detaching any policies the role has before destroying it, refer to [TOP NOTE Section](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) for default value. | `bool` | `true` | no |
| <a name="input_irsa_role_name"></a> [irsa\_role\_name](#input\_irsa\_role\_name) | (optional) Role name created with the IRSA policy | `string` | `""` | no |
| <a name="input_namespace_annotations"></a> [namespace\_annotations](#input\_namespace\_annotations) | (optional) Annotations for namespace created via terraform-kubernetes-provider resource. | `map(string)` | `{}` | no |
| <a name="input_namespace_labels"></a> [namespace\_labels](#input\_namespace\_labels) | (optional)Labels for namespace created via terraform-kubernetes-provider resource. | `map(string)` | `{}` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | (optional) ARN of the policy that is used to set the permissions boundary for the role. | `string` | `null` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | (optional)  Path to the role | `string` | `null` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | (optional) Policies ARNs attached with the IRSA IAM role. Map where key can be any random string and value as a valid policy ARN. | `map(string)` | `{}` | no |
| <a name="input_service_account_annotations"></a> [service\_account\_annotations](#input\_service\_account\_annotations) | (optional) Additional Annotations for the new service account created. | `map(string)` | `{}` | no |
| <a name="input_use_wildcard_namespace_policy"></a> [use\_wildcard\_namespace\_policy](#input\_use\_wildcard\_namespace\_policy) | (optional) Whether to use the wildcard namespace name or not? If set to true then created role can be used by any service account in any namespace. Use it with caution !! | `bool` | `false` | no |
| <a name="input_use_wildcard_service_account_policy"></a> [use\_wildcard\_service\_account\_policy](#input\_use\_wildcard\_service\_account\_policy) | (optional) Whether to use the wildcard service account name or not? The created role can be used by any service account, if use\_wildcard\_namespace is set to false then restricts to namespace variable otherwise otherwise globally. Use it with caution !! | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_irsa_role_name"></a> [irsa\_role\_name](#output\_irsa\_role\_name) | IAM role for the EKS Service Account |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Name of kubernetes namespace |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Name of kubernetes Service Account |

## License

MIT License. See [LICENSE](https://github.com/ishuar/terraform-aws-eks/blob/main/LICENSE) for full details.