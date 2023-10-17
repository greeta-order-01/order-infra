# Resource: Order Postgres Kubernetes Deployment
resource "kubernetes_deployment_v1" "order_postgres_deployment" {
  metadata {
    name = "order-postgres"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "order-postgres"
      }          
    }
    strategy {
      type = "Recreate"
    }  
    template {
      metadata {
        labels = {
          app = "order-postgres"
        }
      }
      spec {
        volume {
          name = "order-postgres-dbcreation-script"
          config_map {
            name = kubernetes_config_map_v1.order_postgres_config_map.metadata.0.name 
          }
        }

        container {
          name = "order-postgres"
          image = "postgres:15.3"
          port {
            container_port = 5432
            name = "postgres"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value = "postgres"
          }

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", "postgres"]
            }
          }          

          volume_mount {
            name = "order-postgres-dbcreation-script"
            mount_path = "/docker-entrypoint-initdb.d"
          }          
        }
      }
    }      
  }
  
}

# Resource: Keyloak Postgres Load Balancer Service
resource "kubernetes_service_v1" "order_postgres_service" {
  metadata {
    name = "order-postgres"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.order_postgres_deployment.spec.0.selector.0.match_labels.app 
    }
    port {
      port        = 5432 # Service Port
      target_port = 5432 # Container Port  # Ignored when we use cluster_ip = "None"
    }
    type = "ClusterIP"
    # load_balancer_ip = "" # This means we are going to use Pod IP   
  }
}

# Resource: order Postgres Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v1" "order_postgres_hpa" {
  metadata {
    name = "order-postgres-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.order_postgres_deployment.metadata[0].name 
    }
    target_cpu_utilization_percentage = 60
  }
}