# Resource: Keycloak Postgres Kubernetes Deployment
resource "kubernetes_deployment_v1" "keycloak_postgres_deployment" {
  metadata {
    name = "keycloak-postgres"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "keycloak-postgres"
      }          
    }
    strategy {
      type = "Recreate"
    }  
    template {
      metadata {
        labels = {
          app = "keycloak-postgres"
        }
      }
      spec {
        volume {
          name = "keycloak-postgres-dbcreation-script"
          config_map {
            name = kubernetes_config_map_v1.keycloak_postgres_config_map.metadata.0.name 
          }
        }

        container {
          name = "keycloak-postgres"
          image = "postgres:15.3"
          port {
            container_port = 5432
            name = "postgres"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value = "postgres"
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }  

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", "postgres"]
            }
          }          

          volume_mount {
            name = "keycloak-postgres-dbcreation-script"
            mount_path = "/docker-entrypoint-initdb.d"
          }          
        }
      }
    }      
  }
  
}

# Resource: Keyloak Postgres Load Balancer Service
resource "kubernetes_service_v1" "keycloak_postgres_service" {
  metadata {
    name = "keycloak-postgres"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.keycloak_postgres_deployment.spec.0.selector.0.match_labels.app 
    }
    port {
      port        = 5432 # Service Port
      target_port = 5432 # Container Port  # Ignored when we use cluster_ip = "None"
    }
    type = "ClusterIP"
    # load_balancer_ip = "" # This means we are going to use Pod IP   
  }
}

# Resource: Keycloak Postgres Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v1" "keycloak_postgres_hpa" {
  metadata {
    name = "keycloak-postgres-hpa"
  }
  spec {
    max_replicas = 2
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = kubernetes_deployment_v1.keycloak_postgres_deployment.metadata[0].name 
    }
    target_cpu_utilization_percentage = 60
  }
}