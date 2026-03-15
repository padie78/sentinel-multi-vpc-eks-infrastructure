# --- CONFIGURACIÓN DE ROLES (DRY) ---
locals {
  # Definimos los roles y sus servicios correspondientes
  iam_roles = {
    cluster = {
      name    = "eks-${var.project_name}-cluster-role"
      service = "eks.amazonaws.com"
    }
    node = {
      name    = "eks-${var.project_name}-node-role"
      service = "ec2.amazonaws.com"
    }
  }

  # Lista de políticas para los workers (Nodos)
  node_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]
}

# Crear Roles de forma dinámica
resource "aws_iam_role" "roles" {
  for_each = local.iam_roles

  name = each.value.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = each.value.service }
    }]
  })

  tags = var.tags
}

# --- ATTACHMENTS ---

# 1. Política para el Clúster
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.roles["cluster"].name
}

# 2. Políticas para los Nodos (Dinamizado con for_each)
resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each   = toset(local.node_policies)
  policy_arn = each.value
  role       = aws_iam_role.roles["node"].name
}

# --- GITHUB ACTIONS ROLE (Mantiene su lógica específica por el OIDC) ---
resource "aws_iam_role" "github_actions_role" {
  name = "sentinel-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = { 
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com" 
      }
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:TU_USUARIO/sentinel-multi-vpc-eks-infrastructure:*"
        }
      }
    }]
  })

  tags = var.tags
}

data "aws_caller_identity" "current" {}