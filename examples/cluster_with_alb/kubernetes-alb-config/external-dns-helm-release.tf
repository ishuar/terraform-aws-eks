resource "helm_release" "external_dns" {

  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "default" # ingress resource is in default namespace.
  timeout    = 200
  atomic     = true

  set {
    name  = "region"
    value = local.aws_region
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external_dns.metadata.0.name
  }

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.alb_example.name
  }
}

