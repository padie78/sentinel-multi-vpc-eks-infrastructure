# ==========================================
# 1. DATA SOURCES
# ==========================================
data "aws_caller_identity" "current" {}

# ==========================================
# 2. DYNAMIC SERVICE ROLES (Cluster & Node)
# ==========================================
resource "aws_iam_role" "roles" {
  for_each = var.service_principals

  name               = each.key == "cluster" ? local.role_names.cluster : local.role_names.node
  assume_role_policy = local.service_trust_policies[each.key]

  tags = var.tags
}

# ==========================================
# 3. POLICY ATTACHMENTS
# ==========================================

# Cluster Control Plane
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = var.cluster_policy_arn
  role       = aws_iam_role.roles["cluster"].name
}

# Worker Nodes
resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each   = toset(var.node_policy_arns)
  policy_arn = each.value
  role       = aws_iam_role.roles["node"].name
}

# ==========================================
# 4. CI/CD: GITHUB ACTIONS ROLE
# ==========================================
resource "aws_iam_role" "github_actions_role" {
  name               = local.role_names.github
  assume_role_policy = local.github_trust_policy

  tags = var.tags
}