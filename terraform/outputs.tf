# ─── VPC Outputs ──────────────────────────────────────────────────────────────

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.nat_gateway_ids
}

output "elastic_ip_addresses" {
  description = "List of Elastic IP addresses for NAT Gateways"
  value       = module.vpc.elastic_ip_addresses
}

# ─── EKS Outputs ──────────────────────────────────────────────────────────────

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint URL of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca_certificate" {
  description = "Base64-encoded certificate authority data for the EKS cluster"
  value       = module.eks.cluster_ca_certificate
  sensitive   = true
}

output "eks_cluster_iam_role_arn" {
  description = "ARN of the IAM role used by the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "eks_node_group_iam_role_arn" {
  description = "ARN of the IAM role used by the EKS node group"
  value       = module.eks.node_group_iam_role_arn
}

output "eks_node_group_name" {
  description = "Name of the EKS managed node group"
  value       = module.eks.node_group_name
}
