# ==========================================
# IAM MODULE OUTPUTS
# ==========================================

output "cluster_role_arn" {
  description = "ARN of the EKS Cluster IAM Role"
  # Acceso directo a la clave del mapa generado por for_each
  value       = try(aws_iam_role.roles["cluster"].arn, null)
}

output "node_role_arn" {
  description = "ARN of the EKS Node Group IAM Role"
  value       = try(aws_iam_role.roles["node"].arn, null)
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions OIDC Role"
  value       = aws_iam_role.github_actions_role.arn
}