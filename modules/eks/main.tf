# ==========================================
# EKS CLUSTER DEFINITION
# ==========================================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  # KMS configuration pulled from centralized feature toggles
  create_kms_key              = local.create_kms_key
  cluster_encryption_config   = {}

  # Networking Configuration
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  # ==========================================
  # IAM: CLUSTER CONTROL PLANE
  # ==========================================
  # Utilizing external roles provisioned in the IAM module to maintain SOC2/Compliance standards
  create_iam_role          = var.create_eks_iam_role 
  iam_role_arn             = var.cluster_role_arn
  iam_role_use_name_prefix = local.iam_role_use_name_prefix
  
  # ==========================================
  # IAM: MANAGED NODE GROUPS
  # ==========================================
  # Global defaults for all node groups using pre-provisioned IAM roles
  eks_managed_node_group_defaults = {
    create_iam_role = var.create_node_iam_role 
    iam_role_arn    = var.node_role_arn        
  }

  # Managed Node Group specifications (capacity, instance types, and scaling)
  eks_managed_node_groups = local.managed_node_group_settings

  # ==========================================
  # LOGGING & AUTHENTICATION
  # ==========================================
  # Operational flags managed in locals.tf to handle resource conflicts and drift
  create_cloudwatch_log_group = local.create_cloudwatch_log_group 
  manage_aws_auth_configmap   = local.manage_aws_auth_configmap   
  
  enable_irsa = var.enable_irsa

  # Combined global and resource-specific tags
  tags = local.cluster_tags
}