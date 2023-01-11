resource "helm_release" "eks_alb" {

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  timeout    = 200
  atomic     = true

  set {
    name  = "region"
    value = "eu-central-1"
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-central-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.alb_example.name
  }
  depends_on = [
    kubernetes_service_account.aws_load_balancer_controller
  ]
}

