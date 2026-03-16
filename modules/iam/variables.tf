# ==========================================
# 1. PROJECT IDENTIFICATION
# ==========================================

variable "project_name" {
  type        = string
  description = "Project identifier used for resource naming prefixes"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository path (owner/repo) for OIDC trust"
}

# ==========================================
# 2. IAM POLICY ARNS (AWS Managed)
# ==========================================

variable "cluster_policy_arn" {
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  description = "Main AWS managed policy for the EKS Cluster Control Plane"
}

variable "node_policy_arns" {
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]
  description = "Standard list of AWS managed policies for EKS Worker Nodes"
}

# ==========================================
# 3. SERVICE CONFIGURATION
# ==========================================

variable "service_principals" {
  type = map(string)
  default = {
    cluster = "eks.amazonaws.com"
    node    = "ec2.amazonaws.com"
  }
  description = "Map of AWS service principals authorized to assume roles"
}

variable "oidc_provider_url" {
  type        = string
  default     = "token.actions.githubusercontent.com"
  description = "OIDC Provider URL for GitHub Actions (Identity Provider)"
}

# ==========================================
# 4. METADATA
# ==========================================

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Global tags to be applied to all IAM resources"
}