module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  cluster_endpoint_public_access = true

  # --- GESTIÓN DE ROLES (Link con tu módulo IAM) ---
  create_iam_role = false               # Evita que el módulo cree un rol genérico
  iam_role_arn    = var.cluster_role_arn # Usa tu 'eks-sentinel-cluster-role'

  enable_irsa = true

  eks_managed_node_groups = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 3
      desired_size = 2

      # --- CONFIGURACIÓN DE ROLES DE NODO ---
      create_iam_role = false             # Evita que cree un rol de nodo genérico
      iam_role_arn    = var.node_role_arn # Usa tu 'eks-sentinel-node-role'
    }
  }

  tags = merge(var.tags, {
    Name = var.cluster_name
  })
}