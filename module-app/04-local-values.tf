# Define Local Values in Terraform
locals {
  environment = var.environment
  name = "order-${var.environment}"
  common_tags = {
    environment = local.environment
  }
  aws_iam_openid_connect_provider_extract_from_arn = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
} 