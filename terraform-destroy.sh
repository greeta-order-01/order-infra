kubectl delete ingress ingress-default
kubectl delete ingress ingress-grafana -n observability-stack
terraform destroy --auto-approve