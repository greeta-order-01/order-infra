resource "kubernetes_config_map_v1" "order" {
  metadata {
    name      = "order"
    labels = {
      app = "order"
    }
  }

  data = {
    "application.yml" = file("${path.module}/app-conf/order.yml")
  }
}

resource "kubernetes_deployment_v1" "order_deployment" {
  depends_on = [kubernetes_deployment_v1.order_postgres_deployment]
  metadata {
    name = "order"
    labels = {
      app = "order"
    }
  }
 
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "order"
      }
    }
    template {
      metadata {
        labels = {
          app = "order"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/path"   = "/actuator/prometheus"
          "prometheus.io/port"   = "8080"
        }        
      }
      spec {
        service_account_name = "spring-cloud-kubernetes"      
        
        container {
          image = "ghcr.io/greeta-order-01/order-service:c5f0bc86eeaaaab8b8538b21ec5f7a3f67a7a3d4"
          name  = "order"
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }
          env {
            name = "SPRING_DATASOURCE_URL"
            value = "jdbc:postgresql://order-postgres:5432/orderdb"
          }            
          env {
            name  = "SPRING_CLOUD_BOOTSTRAP_ENABLED"
            value = "true"
          }

          env {
            name  = "SPRING_CLOUD_KUBERNETES_SECRETS_ENABLEAPI"
            value = "true"
          }

          env {
            name  = "JAVA_TOOL_OPTIONS"
            value = "-javaagent:/workspace/BOOT-INF/lib/opentelemetry-javaagent-1.17.0.jar"
          }

          env {
            name  = "OTEL_SERVICE_NAME"
            value = "order"
          }

          env {
            name  = "OTEL_EXPORTER_OTLP_ENDPOINT"
            value = "http://tempo.observability-stack.svc.cluster.local:4317"
          }

          env {
            name  = "OTEL_METRICS_EXPORTER"
            value = "none"
          }

          # resources {
          #   requests = {
          #     memory = "756Mi"
          #     cpu    = "0.1"
          #   }
          #   limits = {
          #     memory = "756Mi"
          #     cpu    = "2"
          #   }
          # }          

          lifecycle {
            pre_stop {
              exec {
                command = ["sh", "-c", "sleep 5"]
              }
            }
          }

          # liveness_probe {
          #   http_get {
          #     path = "/actuator/health/liveness"
          #     port = 8080
          #   }
          #   initial_delay_seconds = 120
          #   period_seconds        = 15
          # }

          # readiness_probe {
          #   http_get {
          #     path = "/actuator/health/readiness"
          #     port = 8080
          #   }
          #   initial_delay_seconds = 20
          #   period_seconds        = 15
          # }  
         
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "order_hpa" {
  metadata {
    name = "order-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.order_deployment.metadata[0].name 
    }
    target_cpu_utilization_percentage = 70
  }
}

resource "kubernetes_service_v1" "order_service" {
  depends_on = [kubernetes_deployment_v1.order_deployment]
  metadata {
    name = "order"
    labels = {
      app = "order"
      spring-boot = "true"
    }
  }
  spec {
    selector = {
      app = "order"
    }
    port {
      port = 8080
    }
  }
}