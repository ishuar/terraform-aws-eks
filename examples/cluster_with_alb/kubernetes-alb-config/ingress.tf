resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    labels = {
      "app.kubernetes.io/component" = "nginx"
    }
    name      = kubernetes_service_v1.nginx.metadata.0.name
    namespace = "default"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/subnets"         = "${data.aws_subnet.alb_example_public_1.id},${data.aws_subnet.alb_example_public_2.id}"
      "alb.ingress.kubernetes.io/security-groups" = "${aws_security_group.internet_alb.id}"
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = "${data.aws_acm_certificate.alb_example.arn}"
      "alb.ingress.kubernetes.io/target-type"     = "ip" ## When using Service Type ClusterIP, ref = https=//github.com/kubernetes-sigs/aws-load-balancer-controller/issues/1695
    }
  }

  spec {

    ingress_class_name = "alb"

    rule {
      host = "worldofcontainers.tk"
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service_v1.nginx.metadata.0.name
              port {
                number = kubernetes_service_v1.nginx.spec.0.port.0.port
              }
            }
          }
        }
      }
    }
  }
}
