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
  type        = bool
  default     = true
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
}

# ==========================================
# 4. IAM INTEGRATION (Module Interconnectivity)
# ==========================================

variable "create_eks_iam_role" {
  type        = bool
  default     = false # CRITICAL: Set to false to use roles from the central IAM module
  description = "Toggles whether the EKS sub-module should create its own IAM role"
}

variable "create_node_iam_role" {
  type        = bool
  default     = false # CRITICAL: Set to false to use roles from the central IAM module
  description = "Toggles whether the EKS sub-module should create its own Node Group IAM role"
}

variable "cluster_role_arn" {
  type        = string
  description = "ARN of the cluster role provisioned in the modules/iam directory"
}

variable "node_role_arn" {
  type        = string
  description = "ARN of the node role provisioned in the modules/iam directory"
}

variable "enable_irsa" {
  type        = bool
  default     = false
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
}

# ==========================================
# 5. NODE GROUP & CAPACITY
# ==========================================

variable "node_capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "Type of capacity for the managed node group (ON_DEMAND or SPOT)"
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
  description = "List of instance types associated with the EKS Node Group"
}

variable "scaling_config" {
  type = object({
    min_size     = number
    max_size     = number
    desired_size = number
  })
  description = "Configuration block for scaling parameters of the EKS Managed Node Group"
}