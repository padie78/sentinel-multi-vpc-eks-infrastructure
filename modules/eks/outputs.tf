# ==========================================
# EKS MODULE OUTPUTS
# ==========================================

output "cluster_name" {
  value       = module.eks.cluster_name
  description = "The name of the EKS cluster"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The endpoint for the Amazon EKS API server"
}

output "cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "Base64 encoded certificate authority data for the EKS cluster"
}

output "node_security_group_id" {
  value       = module.eks.node_security_group_id
  description = "Security group ID for the EKS worker nodes"
}

output "oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "ARN of the OIDC provider associated with the EKS cluster"
}