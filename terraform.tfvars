# ==========================================
# 1. PROVIDER & GLOBAL CONTEXT
# ==========================================
aws_region   = "us-west-1"
project_name = "sentinel-v3"

# Comentamos las tags para evitar errores de permisos iam:TagRole
# tags = {
#   Project      = "Sentinel"
#   Environment  = "Challenge"
#   Owner        = "Diego Hernan Liascovich"
#   ManagedBy    = "Terraform"
#   Architecture = "Multi-VPC-Peering"
# }

# ==========================================
# 2. NETWORKING
# ==========================================
vpcs = {
  gateway = {
    cidr                 = "10.0.0.0/16"
    public_subnet_count  = 2
    private_subnet_count = 2
    enable_nat_gateway   = false
  },
  # backend = {
  #   cidr                 = "10.1.0.0/16"
  #   public_subnet_count  = 2
  #   private_subnet_count = 2
  #   enable_nat_gateway   = false
  # }
}

# ==========================================
# 3. EKS CONTROL PLANE
# ==========================================
kubernetes_version             = "1.28"
cluster_endpoint_public_access = true

# ==========================================
# 4. EKS CAPACITY & NODES
# ==========================================
instance_types     = ["t3.medium"]
node_capacity_type = "ON_DEMAND"

scaling_config = {
  min_size     = 1
  max_size     = 3
  desired_size = 2
}

# ==========================================
# 5. SECURITY & IAM
# ==========================================
create_eks_iam_role  = true
create_node_iam_role = true
github_repo          = "padie78/sentinel-multi-vpc-eks-infrastructure"