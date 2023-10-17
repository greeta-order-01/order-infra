resource "kubernetes_service_account_v1" "spring_cloud_kubernetes" {
  metadata {
    name      = "spring-cloud-kubernetes"
    namespace = "default"
  }
}

resource "kubernetes_cluster_role_v1" "spring_cloud_kubernetes" {
  metadata {
    name      = "spring-cloud-kubernetes"
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "pods", "services", "endpoints", "secrets"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "spring_cloud_kubernetes" {
  metadata {
    name      = "spring-cloud-kubernetes"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "spring-cloud-kubernetes"
    namespace = "default"
  }

  role_ref {
    kind = "ClusterRole"
    name = "spring-cloud-kubernetes"
    api_group = "rbac.authorization.k8s.io"
  }
}