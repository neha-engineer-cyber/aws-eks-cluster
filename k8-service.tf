resource "kubernetes_service_v1" "example" {
  metadata {
    name = "httpd-service"
    namespace = local.namespace
  }
  spec {
    selector = {
      app = "httpd-app"
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
      node_port = 30008
      protocol = "TCP"
    }

    type = "NodePort"
  }
}
