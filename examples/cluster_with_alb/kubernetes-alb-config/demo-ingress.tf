resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    labels = {
      "app.kubernetes.io/component"          = "nginx"
      "route53-hosted-zone-id"               = aws_route53_zone.internet_alb.id # implicit dependency on route53_hosted_zone.
      "helm-release-name-aws-alb-controller" = helm_release.eks_alb.name        # implicit dependency on aws alb controller.
      "helm-release-external-dns"            = helm_release.external_dns.name   # implicit dependency on external-dns.

    }
    name      = kubernetes_service_v1.nginx.metadata.0.name
    namespace = "default"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/subnets"         = "${data.aws_subnet.alb_example_public_1.id},${data.aws_subnet.alb_example_public_2.id}"
      "alb.ingress.kubernetes.io/security-groups" = aws_security_group.internet_alb.id
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.alb_example.arn
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

  /*
⚠️ IMPORTANT  ⚠️
## Explicit Dependency in case of extra labels (implicit dependency) not required.
?  To create the correct order of terraform destroy.
* external-dns       -> Ingress needs to be deleted first so that external-dns can remove respective records from dns zone.
* aws-alb-controller -> Ingress needs to be deleted before alb-controller gets deleted and remove the ALB
* route53 dns zone   -> route53 dns zone will not be deleted untill external-dns removes the records.
*/
  depends_on = [
    aws_route53_zone.internet_alb,
    helm_release.eks_alb,
    helm_release.external_dns,
  ]
}
