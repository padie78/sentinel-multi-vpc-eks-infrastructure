variable "project_name" {
  description = "Nombre del proyecto para prefijos de recursos"
  type        = string
}

variable "github_repo" {
  description = "Repositorio de GitHub (usuario/repo)"
  type        = string
}

variable "cluster_policy_arn" {
  description = "Política principal para el clúster EKS"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

variable "node_policy_arns" {
  description = "Lista de políticas estándar para los worker nodes"
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]
}

variable "service_principals" {
  description = "Mapa de servicios autorizados para asumir roles"
  type        = map(string)
  default     = {
    cluster = "eks.amazonaws.com"
    node    = "ec2.amazonaws.com"
  }
}

variable "oidc_provider_url" {
  description = "URL del IdP de GitHub Actions"
  type        = string
  default     = "token.actions.githubusercontent.com"
}

variable "tags" {
  description = "Mapa de etiquetas para los recursos"
  type        = map(string)
  default     = {}
}