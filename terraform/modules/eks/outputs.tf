output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint URL of the EKS cluster API server"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64-encoded certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_iam_role_arn" {
  description = "ARN of the IAM role attached to the EKS cluster"
  value       = aws_iam_role.cluster.arn
}

output "cluster_iam_role_name" {
  description = "Name of the IAM role attached to the EKS cluster"
  value       = aws_iam_role.cluster.name
}

output "node_group_iam_role_arn" {
  description = "ARN of the IAM role attached to the EKS node group"
  value       = aws_iam_role.node_group.arn
}

output "node_group_iam_role_name" {
  description = "Name of the IAM role attached to the EKS node group"
  value       = aws_iam_role.node_group.name
}

output "node_group_name" {
  description = "Name of the EKS managed node group"
  value       = aws_eks_node_group.main.node_group_name
}

output "node_group_status" {
  description = "Status of the EKS managed node group"
  value       = aws_eks_node_group.main.status
}
