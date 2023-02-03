module "autoscaler_add_on" {
  source  = "ishuar/eks/aws//modules/helm-add-on"
  version = "~> 1.0"

  name          = "cluster-autoscaler-01"
  repository    = "https://kubernetes.github.io/autoscaler"
  chart         = "cluster-autoscaler"
  chart_version = "9.21.1"
  namespace     = "kube-system"

  values = [
    templatefile("${path.module}/cluster-autoscaler-values.yaml",
      {
        clusterName        = "${local.cluster_name}"
        serviceAccountName = "aws-cluster-autoscaler"
      }
    )
  ]
  set = {
    "awsRegion" = local.aws_region
  }

  # IRSA Attributes
  enable_irsa            = true
  oidc_issuer_url        = module.helm_add_on_eks.eks_cluster_oidc_issuer
  service_account_name   = "aws-cluster-autoscaler"
  irsa_role_name         = "AmazonEKSClusterAutoscalerRole"
  create_service_account = true # as helm relase values has disabled the creation of service account
  role_policy_arns       = { cluster_autoscaler_policy = aws_iam_policy.cluster_autoscaler_policy.arn }

}

