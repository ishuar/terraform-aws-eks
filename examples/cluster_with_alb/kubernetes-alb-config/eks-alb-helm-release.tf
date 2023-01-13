resource "helm_release" "eks_alb" {

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  timeout    = 200
  atomic     = true

  values = [
    file("${path.module}/helm-values/aws-load-balancer-controller-values.yaml")
  ]
  set {
    name  = "region"
    value = local.aws_region
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_load_balancer_controller.metadata.0.name
  }

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.alb_example.name
  }

/*
 ?  To create the correct order of terraform destroy.
 *  policy-and-attachment -> Policy should be attached and available when removing ALB while destruction.
 */
 
  depends_on = [
    aws_iam_role_policy_attachment.alb_policy_attachment,
    aws_iam_policy.alb_controller_policy
  ]
}

