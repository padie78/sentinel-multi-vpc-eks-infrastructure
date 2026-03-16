# ==========================================
# 1. IDENTIFICATION & METADATA
# ==========================================
variable "project_name" {
  type        = string
  description = "Project identifier used for naming prefixes"
}

variable "cluster_name" {
  type        = string
  description = "Unique name for the EKS cluster"
}

variable "tags" {
  type        = map(string)
  description = "Global tags to be applied to all cluster resources"
}

# ==========================================
# 2. NETWORK INTEGRATION
# ==========================================
variable "vpc_id" {
  type        = string
  description = "The VPC ID where the EKS cluster will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private Subnet IDs for EKS nodes and control plane"
}

# ==========================================
# 3. CLUSTER CONFIGURATION
# ==========================================
variable "kubernetes_version" {
  type        = string
  description = "Desired Kubernetes version"
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

# ==========================================
# 4. IAM INTEGRATION (Conexión con módulo IAM)
# ==========================================
variable "create_eks_iam_role" {
  type        = bool
  default     = false # IMPORTANTE: En el módulo EKS debe ser false
  description = "Controla si el sub-módulo de la comunidad debe crear el rol"
}

variable "create_node_iam_role" {
  type        = bool
  default     = false # IMPORTANTE: En el módulo EKS debe ser false
  description = "Controla si el sub-módulo de la comunidad debe crear el rol de nodos"
}

variable "cluster_role_arn" {
  type        = string
  description = "ARN del rol creado en el módulo modules/iam"
}

variable "node_role_arn" {
  type        = string
  description = "ARN del rol de nodos creado en el módulo modules/iam"
}

variable "enable_irsa" {
  type        = bool
  default     = false
}

# ==========================================
# 5. NODE GROUP & CAPACITY
# ==========================================
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