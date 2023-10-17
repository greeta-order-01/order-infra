resource "kubernetes_service_v1" "grafana_service_bridge" {
  metadata {
    name      = "loki-stack-grafana-bridge"
    namespace = "default"
  }

  spec {
    type         = "ExternalName"
    external_name = "loki-stack-grafana.observability-stack"
    port {
      port = 80
    }
  }
}