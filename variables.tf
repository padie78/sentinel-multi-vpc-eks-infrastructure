# ==========================================
# 1. GLOBAL CONTEXT
# ==========================================
variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
}

variable "project_name" {
  type        = string
  description = "Prefix for all resource names"
}

variable "github_repo" {
  type        = string
  description = "Format: owner/repository"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

# ==========================================
# 2. NETWORKING
# ==========================================
variable "vpcs" {
  type = map(object({
    cidr                 = string
    public_subnet_count  = number
    private_subnet_count = number
    enable_nat_gateway   = bool
  }))
}

# ==========================================
# 3. EKS CONFIGURATION
# ==========================================
variable "kubernetes_version" {
  type    = string
  default = "1.31"
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "scaling_config" {
  type = object({
    min_size     = number
    max_size     = number
    desired_size = number
  })
}

# ==========================================
# 4. SECURITY & IAM (Variables añadidas)
# ==========================================
variable "create_eks_iam_role" {
  type    = bool
  default = false
}

variable "create_node_iam_role" {
  type    = bool
  default = false
}