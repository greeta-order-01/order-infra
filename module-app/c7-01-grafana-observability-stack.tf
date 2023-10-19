resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
  }
  depends_on = [helm_release.external_dns]
}

resource "null_resource" "deploy_grafana_script" {
  depends_on = [helm_release.external_dns,
                null_resource.update_kubeconfig] 
  provisioner "local-exec" {
    command = "cd ${path.module}/grafana-observability-stack && sh deploy.sh"
  }
}