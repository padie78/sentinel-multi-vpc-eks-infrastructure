# ==========================================
# MODULE-SPECIFIC LOGICS
# Centralized naming and OIDC condition logic
# ==========================================

locals {
  # ------------------------------------------------------------------
  # RESOURCE NAMING
  # ------------------------------------------------------------------
  role_names = {
    cluster = "eks-${var.project_name}-cluster-role"
    node    = "eks-${var.project_name}-node-role"
    github  = "${var.project_name}-github-actions-role"
  }

  # ------------------------------------------------------------------
  # OIDC CONFIGURATION (GitHub Actions)
  # ------------------------------------------------------------------
  oidc_url = replace(var.oidc_provider_url, "https://", "")
  oidc_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_url}"

  # ------------------------------------------------------------------
  # TRUST POLICIES (AssumeRolePolicies)
  # ------------------------------------------------------------------
  
  # Standard Service Trust Policy (EKS & EC2)
  service_trust_policies = {
    for key, principal in var.service_principals :
    key => jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = principal }
      }]
    })
  }

  # GitHub Actions OIDC Trust Policy
  github_trust_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = { Federated = local.oidc_arn }
      Condition = {
        StringLike = {
          "${local.oidc_url}:sub" = "repo:${var.github_repo}:*"
        }
      }
    }]
  })
}