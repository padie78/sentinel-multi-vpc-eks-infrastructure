# ==========================================
# EKS CLUSTER DEFINITION
# ==========================================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  # Networking
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  # IAM (Usando los roles del módulo de IAM)
  create_iam_role = var.create_eks_iam_role
  iam_role_arn    = var.cluster_role_arn
  enable_irsa     = var.enable_irsa

  # Managed Node Groups
  eks_managed_node_groups = local.managed_node_group_settings

  tags = local.cluster_tags
}