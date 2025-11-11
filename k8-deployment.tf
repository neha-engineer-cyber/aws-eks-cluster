resource "kubernetes_deployment_v1" "example" {
  metadata {
    name = "httpd-deployment"
    labels = {
      app = "httpd-app"
    }
    namespace = local.namespace
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "httpd-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "httpd-app"
        }
      }

      spec {
        container {
          image = "346782563447.dkr.ecr.ca-central-1.amazonaws.com/httpd_app:latest"
          name  = "httpd-container"

          port {
            container_port = 80
            name = "http"
            protocol = "TCP"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

        }
      }
    }
  }
}