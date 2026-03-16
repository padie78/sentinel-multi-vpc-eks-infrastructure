# ==========================================
# IAM MODULE OUTPUTS
# Exports Role ARNs for EKS and CI/CD integration
# ==========================================

output "cluster_role_arn" {
  description = "The ARN of the IAM role for the EKS Cluster Control Plane"
  # Accessing the "cluster" key from the dynamic aws_iam_role.roles resource
  value       = aws_iam_role.roles["cluster"].arn
}

output "node_role_arn" {
  description = "The ARN of the IAM role for the EKS Worker Nodes"
  # Accessing the "node" key from the dynamic aws_iam_role.roles resource
  value       = aws_iam_role.roles["node"].arn
}

output "github_actions_role_arn" {
  description = "The ARN of the IAM role used by the GitHub Actions CI/CD pipeline"
  value       = aws_iam_role.github_actions_role.arn
}