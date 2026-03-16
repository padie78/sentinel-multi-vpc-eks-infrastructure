# ==========================================
# IAM MODULE OUTPUTS
# ==========================================
output "cluster_role_arn" {
  value = aws_iam_role.roles["cluster"].arn
}

output "node_role_arn" {
  value = aws_iam_role.roles["node"].arn
}