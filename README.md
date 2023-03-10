# Introduction

Welcome to the Terraform EKS Module!

Terraform module which creates AWS EKS (Kubernetes) resources. This module makes it easy to create and manage an EKS cluster on AWS, with an example terraform configuration for all necessary resources such as VPC, subnets,etc. This module in the current state only focus on [Managed node groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) concept of worker nodes. The example directory shows how to use the module in a real-world scenario. This module is versioned following semantic versioning. I would love to hear your feedback and see how you're using the module. Please feel free to open an issue on this repository if you have any questions or suggestions.

> :star: This module is motivated from [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks) :star:

## Background Knowledge or External Documentation

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)

## Available Features

- AWS EKS Cluster Addons
- AWS EKS Identity Provider Configuration
- Support for Eks Node groups with Launch Templates
- Global KMS Key Creation for cluster secrets and Node groups EBS volumes.
- VPC Endpoints Creation in case of Private clusters.

## Usage

```hcl
module "eks" {
  source  = "ishuar/eks/aws"
  version = "~> 1.0"

  name                                  = "my-cluster"
  cluster_version                       = "1.24"
  create_eks_cluster                    = true
  create_cluster_iam_role               = true
  attach_cluster_encryption_policy      = true
  create_cloudwatch_log_group           = true
  cluster_iam_role_name                 = "my-cluster-role"
  subnet_ids                            = ["subnet-abcde012", "subnet-bcde012a"]
  vpc_id                                = "vpc-1234556abcdef"
  cluster_additional_security_group_ids = ["sg-123456abcdefg"]

  ## Create Global KMS key for node and EKS cluster encryption.
  create_encryption_kms_key = true

  ## Encryption Config to encrpt secrets for Cluster using Global KMS key created within the module.
  cluster_encryption_config = [
    {
      resources = ["secrets"]
    }
  ]

  # Node groups Config.
  create_node_group          = true
  create_node_group_iam_role = true
  use_launch_template        = true
  node_group_iam_role_name   = "my-nodegroup-role"
  ebs_optimized              = true
  enable_monitoring          = false

  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        encrypted             = true
        delete_on_termination = true
        volume_size           = 80
        volume_type           = "gp3"
      }
    }
  }
  node_groups = {
    node_group_001 = {
      min_size       = 0
      max_size       = 2
      desired_size   = 1
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Examples

- [Complete Private Cluster](https://github.com/ishuar/terraform-eks/tree/main/examples/private_cluster) Cluster using private endpoint with private node groups , only accessible via private ec2 instance managed with SSM.
- [AWS ALB Controller and External DNS with EKS](https://github.com/ishuar/terraform-eks/tree/main/examples/cluster_with_alb) Real world example for How to deploy AWS ALB controller and External DNS add ons in EKS with documentation.
- [AWS EKS Cluster Autoscaler as Helm Add-on](https://github.com/ishuar/terraform-aws-eks/tree/main/examples/cluster-autoscaler-helm-add-on) demonstrate How to deploy AWS EKS cluster Autoscaler as helm addon using  [ishuar/terraform-aws-eks](https://github.com/ishuar/terraform-aws-eks) `helm-add-on` and `irsa` submodules.

## Submodules

- [`helm-add-on`](https://github.com/ishuar/terraform-aws-eks/tree/main/modules/helm-add-on)
- [`irsa`](https://github.com/ishuar/terraform-aws-eks/tree/main/modules/irsa)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_service_linked_role.autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_grant.autoscaling_role_for_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_vpc_endpoint.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ecr_dkr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.elasticloadbalancing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.node_group_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_encryption_kms_key"></a> [create\_encryption\_kms\_key](#input\_create\_encryption\_kms\_key) | (Required) Whether to create the encryption key or not ? | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | (Required) List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) VPC ID where any of the required endpoints would be created( vpc id where EKS is deployed). Required if any of the required endpoints are missing | `string` | n/a | yes |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | (optional) The AMI from which to launch the instance. If not supplied, EKS will use its own default image | `string` | `""` | no |
| <a name="input_attach_cluster_encryption_policy"></a> [attach\_cluster\_encryption\_policy](#input\_attach\_cluster\_encryption\_policy) | (Optional) Indicates whether or not to attach an additional policy for the cluster IAM role to utilize the encryption key provided | `bool` | `true` | no |
| <a name="input_block_device_mappings"></a> [block\_device\_mappings](#input\_block\_device\_mappings) | (optional) Specify volumes to attach to the instance besides the volumes specified by the AMI | `any` | `{}` | no |
| <a name="input_capacity_reservation_specification"></a> [capacity\_reservation\_specification](#input\_capacity\_reservation\_specification) | Targeting for EC2 capacity reservations | `any` | `{}` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | (Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested. | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | (Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `30` | no |
| <a name="input_cluster_additional_security_group_ids"></a> [cluster\_additional\_security\_group\_ids](#input\_cluster\_additional\_security\_group\_ids) | (optional) Additional Security Group IDs attached with EKS cluster. | `list(string)` | `[]` | no |
| <a name="input_cluster_addons"></a> [cluster\_addons](#input\_cluster\_addons) | (optional) Cluster AddOn Config | `any` | `{}` | no |
| <a name="input_cluster_encryption_config"></a> [cluster\_encryption\_config](#input\_cluster\_encryption\_config) | (Optional) Configuration block with encryption configuration for the cluster | `list(any)` | `[]` | no |
| <a name="input_cluster_encryption_policy_description"></a> [cluster\_encryption\_policy\_description](#input\_cluster\_encryption\_policy\_description) | (Optional) Description of the cluster encryption policy created | `string` | `"Cluster encryption policy to allow cluster role to utilize CMK provided"` | no |
| <a name="input_cluster_encryption_policy_name"></a> [cluster\_encryption\_policy\_name](#input\_cluster\_encryption\_policy\_name) | (Optional) Name to use on cluster encryption policy created | `string` | `null` | no |
| <a name="input_cluster_encryption_policy_path"></a> [cluster\_encryption\_policy\_path](#input\_cluster\_encryption\_policy\_path) | (Optional) Cluster encryption policy path | `string` | `null` | no |
| <a name="input_cluster_encryption_policy_tags"></a> [cluster\_encryption\_policy\_tags](#input\_cluster\_encryption\_policy\_tags) | (Optional) A map of additional tags to add to the cluster encryption policy created | `map(string)` | `{}` | no |
| <a name="input_cluster_force_detach_policies"></a> [cluster\_force\_detach\_policies](#input\_cluster\_force\_detach\_policies) | (Optional) Whether to force detaching any policies the role has before destroying it. | `bool` | `true` | no |
| <a name="input_cluster_iam_role_additional_policies"></a> [cluster\_iam\_role\_additional\_policies](#input\_cluster\_iam\_role\_additional\_policies) | (optional) List of additional policies arns attached to EKS cluster iam role | `list(string)` | `[]` | no |
| <a name="input_cluster_iam_role_description"></a> [cluster\_iam\_role\_description](#input\_cluster\_iam\_role\_description) | (Optional) Description of the EKS cluster role. | `string` | `"IAM role for EKS cluster role with required and optional additional iam policies"` | no |
| <a name="input_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#input\_cluster\_iam\_role\_name) | (Optional, Forces new resource) Friendly name of the role for EKS cluster. If omitted, fallback to interpolated name of cluster name and cluster suffix. | `string` | `null` | no |
| <a name="input_cluster_iam_role_path"></a> [cluster\_iam\_role\_path](#input\_cluster\_iam\_role\_path) | (Optional) Path to the EKS cluster role | `string` | `null` | no |
| <a name="input_cluster_iam_role_permissions_boundary"></a> [cluster\_iam\_role\_permissions\_boundary](#input\_cluster\_iam\_role\_permissions\_boundary) | (Optional) ARN of the policy that is used to set the permissions boundary for the EKS cluster role | `string` | `null` | no |
| <a name="input_cluster_iam_role_tags"></a> [cluster\_iam\_role\_tags](#input\_cluster\_iam\_role\_tags) | (optional) Tags attached to iam resources for EKS cluster. | `map(string)` | `{}` | no |
| <a name="input_cluster_tags"></a> [cluster\_tags](#input\_cluster\_tags) | (optional) Key-value map of cluster tags | `map(string)` | `null` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | (Optional) Desired Kubernetes master version. If you do not specify a value, the latest available version at resource creation is used and no upgrades will occur except those automatically triggered by EKS. The value must be configured and increased to upgrade the version when desired. Downgrades are not supported by EKS | `string` | `null` | no |
| <a name="input_cpu_options"></a> [cpu\_options](#input\_cpu\_options) | The CPU options for the instance | `map(string)` | `{}` | no |
| <a name="input_create_autoscaling_service_role"></a> [create\_autoscaling\_service\_role](#input\_create\_autoscaling\_service\_role) | (optional) Whehter the service link role for autoscaling service exists or not ? | `bool` | `false` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | (optional) Whether or not to create the cloudwatch log group for EKS cluster? | `bool` | `true` | no |
| <a name="input_create_cluster_iam_role"></a> [create\_cluster\_iam\_role](#input\_create\_cluster\_iam\_role) | Determines whether a an IAM role is created or to use an existing IAM role for EKS cluster | `bool` | `true` | no |
| <a name="input_create_eks_cluster"></a> [create\_eks\_cluster](#input\_create\_eks\_cluster) | (optional) Whether or not to create a new EKS cluster or to use the existing one | `bool` | `true` | no |
| <a name="input_create_launch_template"></a> [create\_launch\_template](#input\_create\_launch\_template) | Determines whether to create a launch template or not. If set to `false`, EKS will use its own default launch template | `bool` | `true` | no |
| <a name="input_create_node_group"></a> [create\_node\_group](#input\_create\_node\_group) | (optional) Whether or not to create additional node group within the module | `bool` | `true` | no |
| <a name="input_create_node_group_iam_role"></a> [create\_node\_group\_iam\_role](#input\_create\_node\_group\_iam\_role) | (optional) Whether or not to create iam role for node group | `bool` | `true` | no |
| <a name="input_credit_specification"></a> [credit\_specification](#input\_credit\_specification) | Customize the credit specification of the instance | `map(string)` | `{}` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | (Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC\_DEFAULT, RSA\_2048, RSA\_3072, RSA\_4096, ECC\_NIST\_P256, ECC\_NIST\_P384, ECC\_NIST\_P521, or ECC\_SECG\_P256K1. Defaults to SYMMETRIC\_DEFAULT | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | (Optional) Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days. | `number` | `30` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | (optional) If true, enables EC2 instance termination protection | `bool` | `null` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | (optional) If true, the launched EC2 instance(s) will be EBS-optimized | `bool` | `null` | no |
| <a name="input_elastic_gpu_specifications"></a> [elastic\_gpu\_specifications](#input\_elastic\_gpu\_specifications) | (optional) The elastic GPU to attach to the instance | `any` | `{}` | no |
| <a name="input_elastic_inference_accelerator"></a> [elastic\_inference\_accelerator](#input\_elastic\_inference\_accelerator) | (optional) Configuration block containing an Elastic Inference Accelerator to attach to the instance | `map(string)` | `{}` | no |
| <a name="input_enable_ec2_vpc_endpoint"></a> [enable\_ec2\_vpc\_endpoint](#input\_enable\_ec2\_vpc\_endpoint) | (optional) Whether to enable ec2 vpc endpoint or not? Required if cluster is private and there is no existing ec2 vpc endpoint in the respective VPC. | `bool` | `false` | no |
| <a name="input_enable_ecr_api_vpc_endpoint"></a> [enable\_ecr\_api\_vpc\_endpoint](#input\_enable\_ecr\_api\_vpc\_endpoint) | (optional) Whether to enable 'ecr.api' vpc endpoint or not? Required if cluster is private and there is no existing 'ecr.api' vpc endpoint in the respective VPC. | `bool` | `false` | no |
| <a name="input_enable_ecr_dkr_vpc_endpoint"></a> [enable\_ecr\_dkr\_vpc\_endpoint](#input\_enable\_ecr\_dkr\_vpc\_endpoint) | (optional) Whether to enable 'ecr.dkr' vpc endpoint or not? Required if cluster is private and there is no existing 'ecr.dkr' vpc endpoint in the respective VPC. | `bool` | `false` | no |
| <a name="input_enable_elasticloadbalancing_vpc_endpoint"></a> [enable\_elasticloadbalancing\_vpc\_endpoint](#input\_enable\_elasticloadbalancing\_vpc\_endpoint) | (optional) Whether to enable elasticloadbalancing vpc endpoint or not? Required if cluster is private and there is no existing elasticloadbalancing vpc endpoint in the respective VPC. | `bool` | `false` | no |
| <a name="input_enable_logs_vpc_endpoint"></a> [enable\_logs\_vpc\_endpoint](#input\_enable\_logs\_vpc\_endpoint) | (optional) Whether to enable logs vpc endpoint or not? Required if cluster is private and there is no existing logs vpc endpoint in the respective VPC. | `bool` | `false` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | (optional) Enables/disables detailed monitoring | `bool` | `false` | no |
| <a name="input_enable_s3_vpc_endpoint"></a> [enable\_s3\_vpc\_endpoint](#input\_enable\_s3\_vpc\_endpoint) | (optional) Whether to enable s3 vpc endpoint or not? Required if cluster is private and there is no existing s3 vpc endpoint in the respective VPC. | `bool` | `false` | no |
| <a name="input_enable_sts_vpc_endpoint"></a> [enable\_sts\_vpc\_endpoint](#input\_enable\_sts\_vpc\_endpoint) | (optional) Whether to enable sts vpc endpoint or not? Required if cluster is private and there is no existing sts vpc endpoint in the respective VPC. | `bool` | `false` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | (Optional) List of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging | `list(string)` | `null` | no |
| <a name="input_enclave_options"></a> [enclave\_options](#input\_enclave\_options) | (optional) Enable Nitro Enclaves on launched instances | `map(string)` | `{}` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | (Optional) Whether the Amazon EKS private API server endpoint is enabled. Default is false. | `bool` | `null` | no |
| <a name="input_endpoint_private_dns_enabled"></a> [endpoint\_private\_dns\_enabled](#input\_endpoint\_private\_dns\_enabled) | (Optional) AWS services and AWS Marketplace partner services only) Whether or not to associate a private hosted zone with the specified VPC. | `bool` | `false` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | (Optional) Whether the Amazon EKS public API server endpoint is enabled. Default is true. | `bool` | `null` | no |
| <a name="input_endpoint_route_table_ids"></a> [endpoint\_route\_table\_ids](#input\_endpoint\_route\_table\_ids) | (optional) Route table IDs for the S3 Gateway vpc endpoint. Required if cluster is private and s3 gateway endpoint is missing | `list(string)` | `[]` | no |
| <a name="input_endpoint_security_group_ids"></a> [endpoint\_security\_group\_ids](#input\_endpoint\_security\_group\_ids) | (optional) List of security group ids for interface type vpc endpoint. Required if cluster is private and if any of the required endpoints are missing. Security groups should allow atleast 443 traffic within the subnets where EKS cluster is deployed | `list(string)` | `[]` | no |
| <a name="input_instance_market_options"></a> [instance\_market\_options](#input\_instance\_market\_options) | (optional) The market (purchasing) option for the instance | `any` | `{}` | no |
| <a name="input_ip_family"></a> [ip\_family](#input\_ip\_family) | (Optional) The IP family used to assign Kubernetes pod and service addresses. Valid values are ipv4 (default) and ipv6. You can only specify an IP family when you create a cluster, changing this value will force a new cluster to be created | `string` | `null` | no |
| <a name="input_kernel_id"></a> [kernel\_id](#input\_kernel\_id) | The kernel ID | `string` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | (optional) The key name that should be used for the instance(s) | `string` | `null` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | (Optional) Specifies the intended use of the key. Valid values: ENCRYPT\_DECRYPT or SIGN\_VERIFY. Defaults to ENCRYPT\_DECRYPT. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_launch_template_default_version"></a> [launch\_template\_default\_version](#input\_launch\_template\_default\_version) | (optional) Default version of the launch template | `string` | `null` | no |
| <a name="input_launch_template_name"></a> [launch\_template\_name](#input\_launch\_template\_name) | (optional) Name of launch template to be created | `string` | `null` | no |
| <a name="input_launch_template_tags"></a> [launch\_template\_tags](#input\_launch\_template\_tags) | (optional) A map of additional tags to add to the tag\_specifications of launch template created | `map(string)` | `{}` | no |
| <a name="input_license_specifications"></a> [license\_specifications](#input\_license\_specifications) | (optional) A map of license specifications to associate with | `any` | `{}` | no |
| <a name="input_maintenance_options"></a> [maintenance\_options](#input\_maintenance\_options) | (optional) The maintenance options for the instance | `any` | `{}` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | Customize the metadata options for the instance | `map(string)` | <pre>{<br>  "http_endpoint": "enabled",<br>  "http_put_response_hop_limit": 2,<br>  "http_tokens": "required"<br>}</pre> | no |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | (optional) Customize network interfaces to be attached at instance boot time | `list(any)` | `[]` | no |
| <a name="input_node_group_force_detach_policies"></a> [node\_group\_force\_detach\_policies](#input\_node\_group\_force\_detach\_policies) | (Optional) Whether to force detaching any policies the role has before destroying it. | `bool` | `true` | no |
| <a name="input_node_group_iam_role_additional_policies"></a> [node\_group\_iam\_role\_additional\_policies](#input\_node\_group\_iam\_role\_additional\_policies) | (optional) Additional policies to be added to the IAM role for Node Group | `list(string)` | `[]` | no |
| <a name="input_node_group_iam_role_attach_cni_policy"></a> [node\_group\_iam\_role\_attach\_cni\_policy](#input\_node\_group\_iam\_role\_attach\_cni\_policy) | (optional) Whether to attach the `AmazonEKS_CNI_Policy`/`AmazonEKS_CNI_IPv6_Policy` IAM policy to the IAM IAM role. WARNING: If set `false` the permissions must be assigned to the `aws-node` DaemonSet pods via another method or nodes will not be able to join the cluster | `bool` | `true` | no |
| <a name="input_node_group_iam_role_description"></a> [node\_group\_iam\_role\_description](#input\_node\_group\_iam\_role\_description) | (Optional) Description of the role. | `string` | `"IAM role with required and optional additional iam policies for node group role"` | no |
| <a name="input_node_group_iam_role_name"></a> [node\_group\_iam\_role\_name](#input\_node\_group\_iam\_role\_name) | (Optional, Forces new resource) Friendly name of the role for EKS node group. If omitted, fallback to interpolated name of cluster name and node group suffix. | `string` | `null` | no |
| <a name="input_node_group_iam_role_path"></a> [node\_group\_iam\_role\_path](#input\_node\_group\_iam\_role\_path) | (optional) Optional) Path to the node group role | `string` | `null` | no |
| <a name="input_node_group_iam_role_permissions_boundary"></a> [node\_group\_iam\_role\_permissions\_boundary](#input\_node\_group\_iam\_role\_permissions\_boundary) | (optional) (Optional) ARN of the policy that is used to set the permissions boundary for the node group role | `string` | `null` | no |
| <a name="input_node_group_iam_role_tags"></a> [node\_group\_iam\_role\_tags](#input\_node\_group\_iam\_role\_tags) | (optional) Tags attached to iam resources for Node Group | `map(string)` | `{}` | no |
| <a name="input_node_group_timeouts"></a> [node\_group\_timeouts](#input\_node\_group\_timeouts) | (optional) Timeout config for EKS node groups | `map(string)` | <pre>{<br>  "create": "15m",<br>  "delete": "45m",<br>  "update": "15m"<br>}</pre> | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | (optional) Additional node groups configuration | `any` | `{}` | no |
| <a name="input_placement"></a> [placement](#input\_placement) | (optional) The placement of the instance | `map(string)` | `{}` | no |
| <a name="input_private_dns_name_options"></a> [private\_dns\_name\_options](#input\_private\_dns\_name\_options) | (optional) The options for the instance hostname. The default values are inherited from the subnet | `map(string)` | `{}` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | (Optional) List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. Terraform will only perform drift detection of its value when present in a configuration. | `list(string)` | `null` | no |
| <a name="input_ram_disk_id"></a> [ram\_disk\_id](#input\_ram\_disk\_id) | (optional) The ID of the ram disk | `string` | `null` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | (Optional) ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf. Ensure the resource configuration includes explicit dependencies on the IAM Role permissions by adding depends\_on if using the aws\_iam\_role\_policy resource or aws\_iam\_role\_policy\_attachment resource, otherwise EKS cannot delete EKS managed EC2 infrastructure such as Security Groups on EKS Cluster deletion | `string` | `null` | no |
| <a name="input_service_ipv4_cidr"></a> [service\_ipv4\_cidr](#input\_service\_ipv4\_cidr) | (Optional) The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks.for more info. refer [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#service_ipv4_cidr) | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Key-value map of resource tags. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level | `map(string)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (optional) Timeout config for EKS cluster | `map(string)` | <pre>{<br>  "create": "25m",<br>  "delete": "45m",<br>  "update": "25m"<br>}</pre> | no |
| <a name="input_update_launch_template_default_version"></a> [update\_launch\_template\_default\_version](#input\_update\_launch\_template\_default\_version) | (optional) Whether to update the launch templates default version on each update. Conflicts with `launch_template_default_version` | `bool` | `true` | no |
| <a name="input_use_launch_template"></a> [use\_launch\_template](#input\_use\_launch\_template) | (optional) Whether to use the launch template with node groups or not? | `bool` | `false` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | (Optional) The base64-encoded user data to provide when launching the instance. | `string` | `null` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | (optional) A list of security group IDs to associate | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | The Amazon Resource Name (ARN) specifying the log group. Any :* suffix added by the API, denoting all CloudWatch Log Streams under the CloudWatch Log Group, is removed for greater compatibility with other AWS services that do not accept the suffix. |
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | ARN of the cluster. |
| <a name="output_eks_cluster_certificate_authority"></a> [eks\_cluster\_certificate\_authority](#output\_eks\_cluster\_certificate\_authority) | Attribute block containing certificate-authority-data for your cluster. Detailed below. |
| <a name="output_eks_cluster_created_at"></a> [eks\_cluster\_created\_at](#output\_eks\_cluster\_created\_at) | Unix epoch timestamp in seconds for when the cluster was created. |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint for your Kubernetes API server. |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | Name of the cluster. |
| <a name="output_eks_cluster_identity"></a> [eks\_cluster\_identity](#output\_eks\_cluster\_identity) | Attribute block containing identity provider information for your cluster. Only available on Kubernetes version 1.13 and 1.14 clusters created or upgraded on or after September 3, 2019. Detailed below. |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | Name of the eks cluster |
| <a name="output_eks_cluster_oidc_issuer"></a> [eks\_cluster\_oidc\_issuer](#output\_eks\_cluster\_oidc\_issuer) | Issuer URL for the OpenID Connect identity provider. |
| <a name="output_eks_cluster_open_id_provider_arn"></a> [eks\_cluster\_open\_id\_provider\_arn](#output\_eks\_cluster\_open\_id\_provider\_arn) | ARN of the Open-ID provider configurred for the cluster |
| <a name="output_eks_cluster_platform_version"></a> [eks\_cluster\_platform\_version](#output\_eks\_cluster\_platform\_version) | Platform version for the cluster. |
| <a name="output_eks_cluster_primary_security_group_id"></a> [eks\_cluster\_primary\_security\_group\_id](#output\_eks\_cluster\_primary\_security\_group\_id) | Primary security group id of the EKS cluster |
| <a name="output_eks_cluster_status"></a> [eks\_cluster\_status](#output\_eks\_cluster\_status) | Status of the EKS cluster. One of CREATING, ACTIVE, DELETING, FAILED. |
| <a name="output_eks_cluster_tags_all"></a> [eks\_cluster\_tags\_all](#output\_eks\_cluster\_tags\_all) | Map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_eks_cluster_vpc_config"></a> [eks\_cluster\_vpc\_config](#output\_eks\_cluster\_vpc\_config) | Configuration block argument that also includes attributes for the VPC associated with your cluster. Detailed below. |
| <a name="output_global_encryption_kms_key_arn"></a> [global\_encryption\_kms\_key\_arn](#output\_global\_encryption\_kms\_key\_arn) | KMS Key arn used by node groups and the the eks cluster for encryption. |
| <a name="output_node_group_arn"></a> [node\_group\_arn](#output\_node\_group\_arn) | Amazon Resource Name (ARN) of the EKS Node Group. |
| <a name="output_node_group_id"></a> [node\_group\_id](#output\_node\_group\_id) | EKS Cluster name and EKS Node Group name separated by a colon (:). |
| <a name="output_node_group_resources"></a> [node\_group\_resources](#output\_node\_group\_resources) | List of objects containing information about underlying resources. |
| <a name="output_node_group_role_arn"></a> [node\_group\_role\_arn](#output\_node\_group\_role\_arn) | IAM Role Arn used by node groups in the eks cluster |
| <a name="output_node_group_status"></a> [node\_group\_status](#output\_node\_group\_status) | Status of the EKS Node Group. |
| <a name="output_node_group_tags_all"></a> [node\_group\_tags\_all](#output\_node\_group\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |

## License

MIT License. See [LICENSE](https://github.com/ishuar/terraform-aws-eks/blob/main/LICENSE) for full details.