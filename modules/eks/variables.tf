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
# 4. IAM INTEGRATION (External ARNs)
# ==========================================
variable "create_eks_iam_role" {
  type        = bool
  default     = false
  description = "Whether to create a new IAM role for the cluster"
}

variable "create_node_iam_role" {
  type        = bool
  default     = true
  description = "Whether to create a new IAM role for the node groups"
}

variable "cluster_role_arn" {
  type        = string
  default     = null
  description = "Existing IAM role ARN for the cluster control plane"
}

variable "node_role_arn" {
  type        = string
  default     = null
  description = "Existing IAM role ARN for the worker nodes"
}

variable "enable_irsa" {
  type        = bool
  default     = true
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