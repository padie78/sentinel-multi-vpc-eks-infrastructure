# ==========================================
# EKS MODULE LOCALS
# ==========================================

locals {
  # ------------------------------------------------------------------
  # NODE GROUP SETTINGS
  # ------------------------------------------------------------------
  managed_node_group_settings = {
    general = {
      capacity_type  = var.node_capacity_type
      instance_types = var.instance_types

      min_size     = var.scaling_config.min_size
      max_size     = var.scaling_config.max_size
      desired_size = var.scaling_config.desired_size

      # Integración de IAM externa
      create_iam_role = var.create_node_iam_role
      iam_role_arn    = var.node_role_arn
      
      tags = {
        NodeGroup = "general"
        Component = "WorkerNodes"
      }
    }
  }

  # ------------------------------------------------------------------
  # CLUSTER METADATA
  # ------------------------------------------------------------------
  cluster_tags = merge(var.tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    Provisioner                                 = "Terraform"
  })
}