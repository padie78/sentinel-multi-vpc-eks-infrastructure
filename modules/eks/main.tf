module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  cluster_endpoint_public_access = true # Necesario para que GitHub Actions pueda entrar

  # Gestión de Identidad (OIDC) - Crítico para usar Service Accounts en K8s
  enable_irsa = true

  # Configuración de los Nodos (Managed Node Groups)
  eks_managed_node_groups = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND" # O "SPOT" si quieres demostrar ahorro de costos

      min_size     = 1
      max_size     = 3
      desired_size = 2

      # Cumplimos con el prefijo solicitado en el test
      iam_role_name = "eks-${var.cluster_name}-node-role"
    }
  }

  tags = {
    Environment = "Challenge"
    Project     = var.project_name
  }
}