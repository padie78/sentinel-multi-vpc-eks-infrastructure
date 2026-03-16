# ==========================================
# EKS CLUSTER DEFINITION
# ==========================================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  # Desactivamos KMS para evitar errores de políticas con valores null
  create_kms_key              = false
  cluster_encryption_config   = {}

  # Networking
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  # IAM (Conexión directa con tu módulo local de IAM)
  create_iam_role = var.create_eks_iam_role
  
  # IMPORTANTE: Aquí pasamos el output del módulo IAM directamente
  iam_role_arn    = var.cluster_role_arn

  iam_role_use_name_prefix = false
  create_cloudwatch_log_group = true # Cámbialo a true ahora que el CLI confirmó que no existen
  
  enable_irsa     = var.enable_irsa

  # Managed Node Groups (Configurados en tu locals.tf)
  eks_managed_node_groups = local.managed_node_group_settings

  tags = local.cluster_tags
}