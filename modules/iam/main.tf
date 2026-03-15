# --- CONFIGURACIÓN DE ROLES DINÁMICOS ---
resource "aws_iam_role" "roles" {
  for_each = var.service_principals

  # Construcción dinámica: eks-sentinel-cluster-role / eks-sentinel-node-role
  name = "eks-${var.project_name}-${each.key}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = each.value } # Usa el valor del mapa (eks o ec2)
    }]
  })

  tags = var.tags
}

# --- ATTACHMENTS ---

# 1. Política del Clúster
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = var.cluster_policy_arn
  role       = aws_iam_role.roles["cluster"].name
}

# 2. Políticas de los Nodos (Iteración sobre la lista de variables)
resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each   = toset(var.node_policy_arns)
  policy_arn = each.value
  role       = aws_iam_role.roles["node"].name
}

# --- GITHUB ACTIONS ROLE (OIDC 100% DINÁMICO) ---
resource "aws_iam_role" "github_actions_role" {
  # Resulta en: sentinel-github-actions-role
  name = "${var.project_name}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = { 
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider_url}" 
      }
      Condition = {
        StringLike = {
          # Aquí se inyecta dinámicamente la URL y el repositorio
          "${var.oidc_provider_url}:sub" = "repo:${var.github_repo}:*"
        }
      }
    }]
  })

  tags = var.tags
}

data "aws_caller_identity" "current" {}