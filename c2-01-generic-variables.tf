# Input Variables - Placeholder file
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "eu-central-1"  
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "dev"
}
# Business Division
variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "SAP"
}

variable "cluster_name" {
  type = string
  default = "petclinic-online-cluster"
}

variable "ssl_certificate_arn" {
  type = string
  description = "SSL Certificate ARN"
}