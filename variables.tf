#################
# IAM #
#################
variable "create_cluster_iam_role" {
  description = "Determines whether a an IAM role is created or to use an existing IAM role for EKS cluster"
  type        = bool
  default     = true
}
variable "cluster_iam_role_name" {
  type        = string
  description = "(optional) (Optional, Forces new resource) Friendly name of the role for EKS cluster. If omitted, fallback to interpolated name of cluster name and cluster suffix."
  default     = null
}
variable "cluster_iam_role_path" {
  type        = string
  description = "(optional) Optional) Path to the EKS cluster role"
  default     = null
}
variable "cluster_iam_role_description" {
  type        = string
  description = "(Optional) Description of the EKS cluster role."
  default     = "IAM role for EKS cluster role with required and optional additional iam policies"
}
variable "cluster_iam_role_permissions_boundary" {
  type        = string
  description = "(optional) (Optional) ARN of the policy that is used to set the permissions boundary for the EKS cluster role"
  default     = null
}
variable "cluster_force_detach_policies" {
  type        = bool
  description = "(Optional) Whether to force detaching any policies the role has before destroying it."
  default     = true
}
variable "cluster_iam_role_tags" {
  type        = map(string)
  description = "(optional) Tags attached to iam resources for EKS cluster."
  default     = {}
}
variable "cluster_iam_role_additional_policies" {
  type        = list(string)
  description = "(optional) List of additional policies arns attached to EKS cluster iam role"
  default     = []
}
variable "attach_cluster_encryption_policy" {
  description = "Indicates whether or not to attach an additional policy for the cluster IAM role to utilize the encryption key provided"
  type        = bool
  default     = true
}
variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster"
  type        = list(any)
  default     = []
}
variable "cluster_encryption_policy_name" {
  description = "Name to use on cluster encryption policy created"
  type        = string
  default     = null
}
variable "cluster_encryption_policy_description" {
  description = "Description of the cluster encryption policy created"
  type        = string
  default     = "Cluster encryption policy to allow cluster role to utilize CMK provided"
}
variable "cluster_encryption_policy_path" {
  description = "Cluster encryption policy path"
  type        = string
  default     = null
}
variable "cluster_encryption_policy_tags" {
  description = "A map of additional tags to add to the cluster encryption policy created"
  type        = map(string)
  default     = {}
}

variable "encryption_kms_key_arn" {
  type        = string
  description = "(optional) ARN of KMS key used for encryption of EKS cluster"
  default     = null
}
#################
# EKS Cluster #
#################
variable "create_eks_cluster" {
  type        = bool
  description = "(optional) Whether or not to create a new EKS cluster or to use the existing one"
  default     = true
}
variable "name" {
  type        = string
  description = "(Required) Name of the cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumeric characters, dashes and underscores."
}

variable "role_arn" {
  type        = string
  description = "(Required) ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf. Ensure the resource configuration includes explicit dependencies on the IAM Role permissions by adding depends_on if using the aws_iam_role_policy resource or aws_iam_role_policy_attachment resource, otherwise EKS cannot delete EKS managed EC2 infrastructure such as Security Groups on EKS Cluster deletion"
  default     = null
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  description = "(Optional) List of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging"
  default     = null
}
variable "tags" {
  type        = map(string)
  description = "(Optional) Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  default     = null
}
variable "cluster_tags" {
  type        = map(string)
  description = "(optional) Key-value map of cluster tags"
  default     = null
}
variable "cluster_version" {
  type        = string
  description = "(Optional) Desired Kubernetes master version. If you do not specify a value, the latest available version at resource creation is used and no upgrades will occur except those automatically triggered by EKS. The value must be configured and increased to upgrade the version when desired. Downgrades are not supported by EKS"
  default     = null
}

variable "timeouts" {
  type        = map(string)
  description = "(optional) Timeout config for EKS cluster"
  default = {
    create = "25m"
    update = "25m"
    delete = "45m"
  }
}
variable "node_group_timeouts" {
  type        = map(string)
  description = "(optional) Timeout config for EKS node groups"
  default = {
    create = "15m"
    update = "15m"
    delete = "45m"
  }
}

##################
## K8s Network Config
##################

variable "service_ipv4_cidr" {
  type        = string
  description = "(Optional) The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks.for more info. refer [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#service_ipv4_cidr)"
  default     = null
}
variable "ip_family" {
  type        = string
  description = "(Optional) The IP family used to assign Kubernetes pod and service addresses. Valid values are ipv4 (default) and ipv6. You can only specify an IP family when you create a cluster, changing this value will force a new cluster to be created"
  default     = null
}
##################
## VPC Config ###
##################
variable "cluster_additional_security_group_ids" {
  type        = list(string)
  description = "(optional) Additional Security Group IDs attached with EKS cluster."
  default     = []
}

variable "endpoint_private_access" {
  type        = bool
  description = "(Optional) Whether the Amazon EKS private API server endpoint is enabled. Default is false."
  default     = null
}
variable "endpoint_public_access" {
  type        = bool
  description = "(Optional) Whether the Amazon EKS public API server endpoint is enabled. Default is true."
  default     = null
}
variable "public_access_cidrs" {
  type        = list(string)
  description = "(Optional) List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. Terraform will only perform drift detection of its value when present in a configuration."
  default     = null
}
variable "security_group_ids" {
  type        = list(string)
  description = "(Optional) List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane."
  default     = null
}
variable "subnet_ids" {
  type        = list(string)
  description = "(Required) List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}


##################
## SG Config ###
##################

variable "cluster_security_group_additional_rules" {
  type        = any
  description = "(optional) Additional security group rules associated with the security group attached to EKS cluster."
  default     = {}
}

##################
## EKS AddOn ###
##################
variable "cluster_addons" {
  type        = any
  description = "(optional) Cluster AddOn Config"
  default     = {}
}

##################
## Node Group ###
##################
variable "create_node_group" {
  type        = bool
  description = "(optional) Whether or not to create additional node group within the module"
  default     = true
}
variable "node_groups" {
  type        = any
  description = "(optional) Additional node groups configuration"
  default     = {}
}

variable "use_launch_template" {
  type        = bool
  description = "(optional) Whether to use the launch template with node groups or not?"
  default     = false
}
variable "create_node_group_iam_role" {
  type        = bool
  description = "(optional) Whether or not to create iam role for node group"
  default     = true
}
variable "node_group_iam_role_name" {
  type        = string
  description = "(optional) (Optional, Forces new resource) Friendly name of the role for EKS node group. If omitted, fallback to interpolated name of cluster name and node group suffix."
  default     = null
}
variable "node_group_iam_role_attach_cni_policy" {
  type        = bool
  description = "Whether to attach the `AmazonEKS_CNI_Policy`/`AmazonEKS_CNI_IPv6_Policy` IAM policy to the IAM IAM role. WARNING: If set `false` the permissions must be assigned to the `aws-node` DaemonSet pods via another method or nodes will not be able to join the cluster"
  default     = true
}
variable "node_group_iam_role_path" {
  type        = string
  description = "(optional) Optional) Path to the node group role"
  default     = null
}
variable "node_group_iam_role_description" {
  type        = string
  description = "(Optional) Description of the role."
  default     = "IAM role with required and optional additional iam policies for node group role"
}
variable "node_group_iam_role_permissions_boundary" {
  type        = string
  description = "(optional) (Optional) ARN of the policy that is used to set the permissions boundary for the node group role"
  default     = null
}
variable "node_group_force_detach_policies" {
  type        = bool
  description = "(Optional) Whether to force detaching any policies the role has before destroying it."
  default     = true
}
variable "node_group_iam_role_tags" {
  type        = map(string)
  description = "(optional) Tags attached to iam resources for Node Group"
  default     = {}
}
variable "node_group_iam_role_additional_policies" {
  description = "Additional policies to be added to the IAM role for Node Group"
  type        = list(string)
  default     = []
}
#####################
## Cloudwatch LogGroup #
#####################

variable "create_cloudwatch_log_group" {
  type        = bool
  description = "(optional) Whether or not to create the cloudwatch log group for EKS cluster?"
  default     = true
}
variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  default     = 30
}
variable "cloudwatch_log_group_kms_key_id" {
  type        = string
  description = "(Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
  default     = null
}

################################################################################
# Launch template
################################################################################
variable "create_launch_template" {
  description = "Determines whether to create a launch template or not. If set to `false`, EKS will use its own default launch template"
  type        = bool
  default     = true
}

variable "launch_template_name" {
  description = "Name of launch template to be created"
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance(s) will be EBS-optimized"
  type        = bool
  default     = null
}

variable "ami_id" {
  description = "The AMI from which to launch the instance. If not supplied, EKS will use its own default image"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "The key name that should be used for the instance(s)"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate"
  type        = list(string)
  default     = []
}

variable "launch_template_default_version" {
  description = "Default version of the launch template"
  type        = string
  default     = null
}

variable "update_launch_template_default_version" {
  description = "Whether to update the launch templates default version on each update. Conflicts with `launch_template_default_version`"
  type        = bool
  default     = true
}

variable "disable_api_termination" {
  description = "If true, enables EC2 instance termination protection"
  type        = bool
  default     = null
}

variable "kernel_id" {
  description = "The kernel ID"
  type        = string
  default     = null
}

variable "ram_disk_id" {
  description = "The ID of the ram disk"
  type        = string
  default     = null
}

variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type        = any
  default     = {}
}

variable "capacity_reservation_specification" {
  description = "Targeting for EC2 capacity reservations"
  type        = any
  default     = {}
}

variable "cpu_options" {
  description = "The CPU options for the instance"
  type        = map(string)
  default     = {}
}

variable "credit_specification" {
  description = "Customize the credit specification of the instance"
  type        = map(string)
  default     = {}
}

variable "elastic_gpu_specifications" {
  description = "The elastic GPU to attach to the instance"
  type        = any
  default     = {}
}

variable "elastic_inference_accelerator" {
  description = "Configuration block containing an Elastic Inference Accelerator to attach to the instance"
  type        = map(string)
  default     = {}
}

variable "enclave_options" {
  description = "Enable Nitro Enclaves on launched instances"
  type        = map(string)
  default     = {}
}

variable "instance_market_options" {
  description = "The market (purchasing) option for the instance"
  type        = any
  default     = {}
}

variable "maintenance_options" {
  description = "The maintenance options for the instance"
  type        = any
  default     = {}
}

variable "license_specifications" {
  description = "A map of license specifications to associate with"
  type        = any
  default     = {}
}

variable "metadata_options" {
  description = "Customize the metadata options for the instance"
  type        = map(string)
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring"
  type        = bool
  default     = false
}

variable "network_interfaces" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(any)
  default     = []
}

variable "placement" {
  description = "The placement of the instance"
  type        = map(string)
  default     = {}
}

variable "private_dns_name_options" {
  description = "The options for the instance hostname. The default values are inherited from the subnet"
  type        = map(string)
  default     = {}
}

variable "launch_template_tags" {
  description = "A map of additional tags to add to the tag_specifications of launch template created"
  type        = map(string)
  default     = {}
}
variable "user_data" {
  type        = string
  description = "(Optional) The base64-encoded user data to provide when launching the instance."
  default     = null
}


#######################
## VPC Endpoints  Config ###
#######################
variable "vpc_id" {
  type        = string
  description = "(optional)VPC ID where any of the required endpoints would be created( vpc id where EKS is deployed). Required if any of the required endpoints are missing"
}
variable "enable_ec2_vpc_endpoint" {
  type        = bool
  description = "(optional) Whether to enable ec2 vpc endpoint or not? Required if cluster is private and there is no existing ec2 vpc endpoint in the respective VPC."
  default     = false
}
variable "enable_elasticloadbalancing_vpc_endpoint" {
  type        = bool
  description = "(optional) Whether to enable elasticloadbalancing vpc endpoint or not? Required if cluster is private and there is no existing elasticloadbalancing vpc endpoint in the respective VPC."
  default     = false
}
variable "enable_ecr_api_vpc_endpoint" {
  type        = bool
  description = "(optional) Whether to enable 'ecr.api' vpc endpoint or not? Required if cluster is private and there is no existing 'ecr.api' vpc endpoint in the respective VPC."
  default     = false
}
variable "enable_ecr_dkr_vpc_endpoint" {
  type        = bool
  description = "(optional) Whether to enable 'ecr.dkr' vpc endpoint or not? Required if cluster is private and there is no existing 'ecr.dkr' vpc endpoint in the respective VPC."
  default     = false
}
variable "enable_sts_vpc_endpoint" {
  type        = bool
  description = "(optional) Whether to enable sts vpc endpoint or not? Required if cluster is private and there is no existing sts vpc endpoint in the respective VPC."
  default     = false
}
variable "enable_logs_vpc_endpoint" {
  type        = bool
  description = "(optional) Whether to enable logs vpc endpoint or not? Required if cluster is private and there is no existing logs vpc endpoint in the respective VPC."
  default     = false
}
variable "enable_s3_vpc_endpoint" {
  type        = bool
  description = "(optional) Whether to enable s3 vpc endpoint or not? Required if cluster is private and there is no existing s3 vpc endpoint in the respective VPC."
  default     = false
}

variable "endpoint_security_group_ids" {
  type        = list(string)
  description = "(optional) List of security group ids for interface type vpc endpoint. Required if cluster is private and if any of the required endpoints are missing. Security groups should allow atleast 443 traffic within the subnets where EKS cluster is deployed"
  default     = []
}

variable "endpoint_private_dns_enabled" {
  type        = bool
  description = "(Optional) AWS services and AWS Marketplace partner services only) Whether or not to associate a private hosted zone with the specified VPC."
  default     = false
}
variable "endpoint_route_table_ids" {
  type        = list(string)
  description = "(optional) Route table IDs for the S3 Gateway vpc endpoint. Required if cluster is private and s3 gateway endpoint is missing"
  default     = []
}

#######################
## Global KMS key Config ###
#######################
variable "create_encryption_kms_key" {
  type        = bool
  description = "(optional) describe your variable"
}
variable "deletion_window_in_days" {
  type        = number
  description = "(Optional) Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
  default     = 30
}

variable "key_usage" {
  type        = string
  description = "(Optional) Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. Defaults to ENCRYPT_DECRYPT."
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  type        = string
  description = "(Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT"
  default     = "SYMMETRIC_DEFAULT"
}
variable "create_autoscaling_service_role" {
  type        = bool
  description = "(optional) Whehter the service link role for autoscaling service exists or not ?"
  default     = false
}
