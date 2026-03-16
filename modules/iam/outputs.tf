# ==========================================
# IAM MODULE OUTPUTS
# ==========================================

output "cluster_role_arn" {
  description = "ARN of the EKS Cluster IAM Role"
  # lookup busca la clave "cluster" en el mapa 'roles'. 
  # Si no existe, devuelve null en lugar de romper el despliegue.
  value       = lookup(aws_iam_role.roles, "cluster", null) != null ? aws_iam_role.roles["cluster"].arn : null
}

output "node_role_arn" {
  description = "ARN of the EKS Node Group IAM Role"
  # Aplicamos la misma lógica para el rol de los nodos.
  value       = lookup(aws_iam_role.roles, "node", null) != null ? aws_iam_role.roles["node"].arn : null
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions OIDC Role"
  value       = aws_iam_role.github_actions_role.arn
}