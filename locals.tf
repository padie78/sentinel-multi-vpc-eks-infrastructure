# ==========================================
# INFRASTRUCTURE LOGICS & TRANSFORMATIONS
# ==========================================

locals {
  # ------------------------------------------------------------------
  # DYNAMIC NAMES (Pre-calculados)
  # ------------------------------------------------------------------
  cluster_names = {
    for k, v in var.vpcs : k => "${var.project_name}-eks-${k}"
  }

  # ------------------------------------------------------------------
  # VPC PEERING CONFIGURATION
  # ------------------------------------------------------------------
  vpc_peerings = {
    "gw_to_be" = { 
      source_key = "gateway"
      dest_key   = "backend"
      name       = "${var.project_name}-peering-gw-to-be"
    },
    "be_to_gw" = { 
      source_key = "backend"
      dest_key   = "gateway"
      name       = "${var.project_name}-peering-be-to-gw"
    }
  }
}