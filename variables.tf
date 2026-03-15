# --- Identificación ---
variable "project_name" {
  type    = string
  default = "sentinel"
}

variable "github_repo" {
  type        = string
  description = "Usuario/Repo para OIDC (ej: diegoliascovich/repo)"
}

variable "tags" {
  type = map(string)
}

# --- Networking (Mapa para for_each) ---
variable "vpcs" {
  description = "Configuración de las VPCs"
  type = map(object({
    cidr                 = string
    public_subnet_count  = number
    private_subnet_count = number
    enable_nat_gateway   = bool
  }))
}

# --- EKS Config & Capacity (Esto limpia los errores de la imagen) ---
variable "scaling_config" {
  type = object({
    min_size     = number
    max_size     = number
    desired_size = number
  })
}

variable "kubernetes_version" {
  type    = string
  default = "1.28"
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "node_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

# --- IAM Logic ---
variable "create_eks_iam_role" {
  type    = bool
  default = false
}

variable "create_node_iam_role" {
  type    = bool
  default = false
}