// Provided at runtime

variable "region" {
  type = string
  description = "AWS region"
}

variable "author" {
  type = string
  description = "Created by"
}

// Default values

variable "vpc_name" {
  type = string
  description = "VPC name"
  default     = "sandbox"
}

variable "cidr_block" {
  type = string
  description = "VPC CIDR block"
  default     = "10.1.0.0/16"
}

variable "cluster_name" {
  type = string
  description = "EKS cluster name"
}

variable "public_subnets_count" {
  type = number
  description = "Number of public subnets"
  default = 2
}