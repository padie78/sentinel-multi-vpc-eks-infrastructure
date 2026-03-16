# ==========================================
# IAM MODULE OUTPUTS
# ==========================================

output "cluster_role_arn" {
  description = "ARN of the EKS Cluster IAM Role"
  # Acceso directo a la clave del mapa generado por for_each
  value       = try(aws_iam_role.roles["cluster"].arn, null)
}

output "cluster_role_arn" {
  value = aws_iam_role.roles["cluster"].arn
}

output "node_role_arn" {
  value = aws_iam_role.roles["node"].arn
}