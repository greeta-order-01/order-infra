output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.sandbox.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = var.cidr_block
}

# VPC Public Subnets
output "vpc_public_subnets" {
  description = "List of IDs of public subnets"
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "vpc_public_subnets_count" {
  value       = var.public_subnets_count
}

output "cluster_id" {
  description = "Cluster ID"
  value       = aws_eks_cluster.sandbox.id
}

output "cluster_name" {
  description = "Cluster Name"
  value       = aws_eks_cluster.sandbox.name
}