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

  # IAM (Using external roles from the root/iam module)
  create_iam_role = var.create_eks_iam_role
  iam_role_arn    = var.cluster_role_arn
  enable_irsa     = var.enable_irsa

  # Managed Node Groups (Aquí es donde entra la configuración de tu locals.tf)
  eks_managed_node_groups = local.managed_node_group_settings

  tags = local.cluster_tags
}