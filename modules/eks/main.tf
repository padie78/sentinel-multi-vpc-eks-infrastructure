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

  # ==========================================
  # IAM: CLUSTER CONTROL PLANE
  # ==========================================
  # Usamos el rol que viene desde la raíz (creado en modules/iam)
  create_iam_role          = var.create_eks_iam_role # Será 'false'
  iam_role_arn             = var.cluster_role_arn
  iam_role_use_name_prefix = false
  
  # ==========================================
  # IAM: MANAGED NODE GROUPS
  # ==========================================
  # Aplicamos la configuración de IAM a TODOS los node groups por defecto
  eks_managed_node_group_defaults = {
    create_iam_role = var.create_node_iam_role # Será 'false'
    iam_role_arn    = var.node_role_arn        # Pasamos el ARN de tu módulo IAM
  }

  # Configuración específica de los nodos (instancias, capacidad, etc.)
  eks_managed_node_groups = local.managed_node_group_settings

  # ==========================================
  # LOGS & AUTH
  # ==========================================
  # Desactivamos la creación automática de Log Groups para evitar el error 
  # 'ResourceAlreadyExistsException' que vimos en el apply anterior.
  create_cloudwatch_log_group = false 
  
  # Desactiva la gestión automática para evitar el error de conexión al principio
  manage_aws_auth_configmap = false 
  
  enable_irsa = var.enable_irsa

  tags = local.cluster_tags
}