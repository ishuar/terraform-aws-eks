# Kubernetes ALB Service Account
resource "kubernetes_service_account" "external_dns" {
  metadata {
    labels = {
      "app.kubernetes.io/name" : "external-dns"
    }
    name      = "external-dns"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" : "${aws_iam_role.external_dns.arn}"
    }
  }
}
