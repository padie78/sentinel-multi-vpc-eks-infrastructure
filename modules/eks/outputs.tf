output "cluster_endpoint" {
  description = "Endpoint para el API server de EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "ID del security group creado por el módulo"
  value       = module.eks.cluster_security_group_id
}

output "cluster_name" {
  description = "Nombre del clúster para configurar kubectl"
  value       = module.eks.cluster_name
}