variable "project_name" { type = string }
variable "cluster_name" { type = string }
variable "tags"         { type = map(string) }

# Networking inyectado
variable "vpc_id"     { type = string }
variable "subnet_ids" { type = list(string) }

# EKS Config
variable "kubernetes_version"             { 
  type = string 
  default = "1.28" 
}

variable "cluster_endpoint_public_access" { 
  type = bool   
  default = true 
}

# IAM (ARNs que vienen del módulo IAM raíz)
variable "cluster_role_arn" { 
    type = string 
    default = null 
}

variable "node_role_arn" {
  type    = string
  default = null
}

# Capacity & Scaling
variable "node_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}
variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}
variable "scaling_config" {
  type = object({
    min_size     = number
    max_size     = number
    desired_size = number
  })
}

# Flags
variable "create_eks_iam_role" {
  type    = bool
  default = false
}
variable "create_node_iam_role" {
  type    = bool
  default = false
}