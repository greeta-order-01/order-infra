resource "kubernetes_deployment_v1" "order_ui_deployment" {
  depends_on = [kubernetes_deployment_v1.order_deployment]
  metadata {
    name = "order-ui"
    labels = {
      app = "order-ui"
    }
  }
 
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "order-ui"
      }
    }
    template {
      metadata {
        labels = {
          app = "order-ui"
        }
      }
      spec {
        container {
          image = "ghcr.io/greeta-order-01/order-ui"
          name  = "order-ui"
          image_pull_policy = "Always"
          port {
            container_port = 4200
          }                                                                                          
        }
      }
    }
  }
}

# Resource: Keycloak Server Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v1" "order_ui_hpa" {
  metadata {
    name = "order-ui-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.order_ui_deployment.metadata[0].name
    }
    target_cpu_utilization_percentage = 50
  }
}

resource "kubernetes_service_v1" "order_ui_service" {
  depends_on = [kubernetes_deployment_v1.order_ui_deployment]
  metadata {
    name = "order-ui"
  }
  spec {
    selector = {
      app = "order-ui"
    }
    port {
      port = 4200
    }
  }
}
