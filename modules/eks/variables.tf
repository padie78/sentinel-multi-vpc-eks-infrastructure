variable "cluster_role_arn" {
  description = "ARN del rol de IAM para el clúster de EKS (creado en el módulo IAM)"
  type        = string
}

variable "node_role_arn" {
  description = "ARN del rol de IAM para los nodos de EKS (creado en el módulo IAM)"
  type        = string
}

# Aprovecha para asegurarte de que estas también existan:
variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "tags" {
  description = "Mapa de etiquetas para los recursos del clúster"
  type        = map(string)
  default     = {}
}