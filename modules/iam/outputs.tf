output "cluster_role_arn" {
  value       = aws_iam_role.eks_cluster_role.arn
  description = "ARN para el Control Plane de EKS"
}

output "node_role_arn" {
  value       = aws_iam_role.eks_node_role.arn
  description = "ARN para los Worker Nodes de EKS"
}