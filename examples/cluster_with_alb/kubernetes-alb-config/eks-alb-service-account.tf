# Kubernetes ALB Service Account
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    labels = {
      "app.kubernetes.io/component" : "controller"
      "app.kubernetes.io/name" : "aws-load-balancer-controller"
    }
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" : "${aws_iam_role.alb_controller_role.arn}"
    }
  }
}
