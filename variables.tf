# ==========================================
# 1. GLOBAL CONTEXT
# ==========================================
variable "aws_region" {
  type        = string
  description = "The AWS region where all infrastructure resources will be provisioned."
}

variable "project_name" {
  type        = string
  description = "Global project identifier used as a prefix for consistent resource naming."
}

variable "github_repo" {
  type        = string
  description = "GitHub repository path (owner/repository) used for OIDC trust identity and CI/CD integration."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to all resources for billing and organizational purposes."
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
  description = "Configuration map for VPCs, defining CIDR blocks, subnet distribution, and NAT Gateway requirements for each environment (e.g., Gateway, Backend)."
}

# ==========================================
# 3. EKS CONFIGURATION
# ==========================================
variable "kubernetes_version" {
  type        = string
  default     = "1.31"
  description = "Specified Kubernetes version for the EKS Control Plane."
}

variable "cluster_endpoint_public_access" {
  type        = bool
  default     = true
  description = "Indicates whether the Amazon EKS public API server endpoint is enabled for external management."
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "List of EC2 instance types for the EKS Managed Node Groups."
}

variable "node_capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "Purchase option for EKS nodes: ON_DEMAND or SPOT."
}

variable "scaling_config" {
  type = object({
    min_size     = number
    max_size     = number
    desired_size = number
  })
  description = "Scaling parameters defining the minimum, maximum, and desired number of worker nodes."
}

# ==========================================
# 4. SECURITY & IAM (Control Flags)
# ==========================================
variable "create_eks_iam_role" {
  type        = bool
  default     = false
  description = "Toggle to determine if the EKS module should create its own IAM role or use an externally provisioned one."
}

variable "create_node_iam_role" {
  type        = bool
  default     = false
  description = "Toggle to determine if the EKS Node Group should create its own IAM role or use an externally provisioned one."
}