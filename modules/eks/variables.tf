variable "cluster_name" {
  type        = string
  description = "Nombre del cluster (ej: eks-sentinel-gateway)"
}

variable "vpc_id" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "project_name" {
  type    = string
  default = "sentinel"
}