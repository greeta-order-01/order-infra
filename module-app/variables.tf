variable "region" {
  type = string
  description = "AWS region"
}

variable "cluster_id" {
  description = "Name of the EKS cluster where the ingress nginx will be deployed"
  type        = string

}

variable "cluster_name" {
  type = string
  description = "EKS cluster name"
}

variable "environment" {
  description = "EKS Cluster Environment"
  type        = string
}

variable "ssl_certificate_arn" {
  description = "SSL Certificate ARN"
  type        = string
}

variable "domain_name" {
  description = "Domain Name"
  type        = string
}

# EKS OIDC ROOT CA Thumbprint - valid until 2037
variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

variable "vpc_id" {
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
}

variable "vpc_public_subnets" {
  type        = list(string)
}

variable "vpc_public_subnets_count" {
  type = number
}