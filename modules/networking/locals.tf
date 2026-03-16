# ==========================================
# MODULE-SPECIFIC LOGICS
# Centralized naming and tagging conventions
# ==========================================

locals {
  # ------------------------------------------------------------------
  # RESOURCE NAMING
  # Construct a unique prefix for all resources within this module
  # ------------------------------------------------------------------
  name_prefix = "${var.project_name}-${var.vpc_name}"

  # STATIC NAMES
  # Centralized map for resources that are unique per VPC
  names = {
    vpc        = "${local.name_prefix}-vpc"
    igw        = "${local.name_prefix}-igw"
    nat        = "${local.name_prefix}-nat"
    nat_eip    = "${local.name_prefix}-nat-eip"
    public_rt  = "${local.name_prefix}-pub-rt"
    private_rt = "${local.name_prefix}-priv-rt"
  }

  az_state_filter = "available"

  # DYNAMIC NAMES (Subnets)
  # Pre-calculating names based on available Availability Zones
  # This avoids complex string interpolation inside main.tf
  public_subnet_names = [
    for az in data.aws_availability_zones.available.names : 
    "${local.name_prefix}-pub-${az}"
  ]

  private_subnet_names = [
    for az in data.aws_availability_zones.available.names : 
    "${local.name_prefix}-priv-${az}"
  ]

  # ------------------------------------------------------------------
  # GLOBAL TAGS
  # Standardized metadata applied to all resources
  # ------------------------------------------------------------------
  common_tags = merge(var.tags, {
    VPC_Group   = var.vpc_name
    Project     = var.project_name
    Provisioner = "Terraform"
  })

  # ------------------------------------------------------------------
  # EKS-SPECIFIC TAGS (LBC Integration)
  # Required by the AWS Load Balancer Controller to auto-discover subnets
  # ------------------------------------------------------------------
  eks_public_tags  = { 
    "kubernetes.io/role/elb" = "1" 
  }

  eks_private_tags = { 
    "kubernetes.io/role/internal-elb" = "1" 
  }
}