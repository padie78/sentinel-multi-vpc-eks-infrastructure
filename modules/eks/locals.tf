# ==========================================
# EKS MODULE LOCALS
# ==========================================

locals {
  # ------------------------------------------------------------------
  # FEATURE TOGGLES & FLAGS
  # ------------------------------------------------------------------
  # These flags are centralized to prevent resource conflicts and 
  # bypass default module behaviors that were causing deployment errors.
  
  create_kms_key              = false # Disabled to avoid complex CMK policy management
  iam_role_use_name_prefix    = false # Ensures predictable naming for IAM roles
  create_cloudwatch_log_group = false # Prevents ResourceAlreadyExistsException if logs exist
  manage_aws_auth_configmap   = false # Manual auth management to avoid initial handshake issues

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

      # External IAM Integration (Using roles from the central IAM module)
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