## Service for Deployment
resource "kubernetes_service_v1" "nginx" {
  metadata {
    name      = kubernetes_deployment_v1.nginx.metadata.0.name
    namespace = "default"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.nginx.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}