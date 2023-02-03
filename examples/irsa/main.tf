data "aws_caller_identity" "current" {}

module "complete_irsa" {
  source  = "ishuar/eks/aws//modules/irsa"
  version = "~> 1.4"

  enable_irsa                         = true
  oidc_issuer_url                     = module.irsa_eks.eks_cluster_oidc_issuer
  irsa_role_name                      = "${local.service_account_names.complete_service_account_name}-Role"
  role_path                           = "/"
  force_detach_policies               = true
  permissions_boundary                = null
  role_policy_arns                    = { example_policy = aws_iam_policy.example_irsa_policy["complete_service_account_name"].arn }
  use_wildcard_service_account_policy = false
  use_wildcard_namespace_policy       = false
  aws_account_id                      = data.aws_caller_identity.current.account_id
  create_kubernetes_namespace         = true
  namespace                           = "irsa"
  namespace_labels                    = { "provisioner" = "terraform" }
  namespace_annotations               = { "environment" = "dev" }
  create_service_account              = true
  service_account_name                = local.service_account_names.complete_service_account_name
  service_account_annotations         = { "provisioner" = "terraform", "environment" = "dev" }
  automount_service_account_token     = true

  depends_on = [module.irsa_eks]
}

module "minimal_irsa" {
  source  = "ishuar/eks/aws//modules/irsa"
  version = "~> 1.4"

  oidc_issuer_url      = module.irsa_eks.eks_cluster_oidc_issuer
  service_account_name = local.service_account_names.minimal_service_account_name
  namespace            = "irsa"


  depends_on = [module.irsa_eks]

  ## This ROLE on Service Account won't have any policies attached. for attaching policies use variable role_policy_arns
  ## map of strings is acceptable where key can be any random string and value as a valid policy ARN.
  # role_policy_arns = {example_policy = aws_iam_policy.example_irsa_policy["minimal_service_account_name"].arn }
}
