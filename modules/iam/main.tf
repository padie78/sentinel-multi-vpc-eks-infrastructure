# ==========================================
# 1. DATA SOURCES
# ==========================================
data "aws_caller_identity" "current" {}

# ==========================================
# 2. DYNAMIC SERVICE ROLES (Cluster & Node)
# ==========================================
resource "aws_iam_role" "roles" {
  for_each = {
    for k, v in var.service_principals : k => v 
    if (k == "cluster" && var.create_eks_iam_role) || (k == "node" && var.create_node_iam_role)
  }

  # Usamos local.role_names que es como lo tienes en tu locals.tf
  name               = each.key == "cluster" ? local.role_names.cluster : local.role_names.node
  assume_role_policy = local.service_trust_policies[each.key]

  # Se eliminan los tags para evitar conflictos con la política restrictiva de IAM
}

# ==========================================
# 3. POLICY ATTACHMENTS
# ==========================================

# EKS Cluster Control Plane
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  count      = var.create_eks_iam_role ? 1 : 0
  
  policy_arn = var.cluster_policy_arn
  role       = aws_iam_role.roles["cluster"].name
}

# EKS Worker Nodes
resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each   = var.create_node_iam_role ? toset(var.node_policy_arns) : []
  
  policy_arn = each.value
  role       = aws_iam_role.roles["node"].name
}

# ==========================================
# 4. CI/CD: GITHUB ACTIONS ROLE
# ==========================================
resource "aws_iam_role" "github_actions_role" {
  name               = local.role_names.github  
  assume_role_policy = local.github_trust_policy
}