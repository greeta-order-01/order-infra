# Define Local Values in Terraform
locals {
  env_name         = var.environment
  aws_region       = var.aws_region
  cluster_name     = var.cluster_name
}