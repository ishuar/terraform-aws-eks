# ref: https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns
resource "helm_release" "external_dns" {

  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "default" # ingress resource is in default namespace.
  timeout    = 200
  atomic     = false

  values = [
    file("${path.module}/helm-values/external-dns-values.yaml")
  ]

  set {
    name  = "region"
    value = local.aws_region
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external_dns.metadata.0.name
  }

  /*
?  To create the correct order of terraform destroy.
* policy-and-attachment -> Policy should be attached and available to external-dns to have access for removing the dns records.
* route53 dns zone      -> route53 dns zone will not be deleted untill external-dns removes the records.
*/

  depends_on = [
    aws_route53_zone.internet_alb,
    aws_iam_role_policy_attachment.external_dns,
    aws_iam_policy.external_dns
  ]
}
