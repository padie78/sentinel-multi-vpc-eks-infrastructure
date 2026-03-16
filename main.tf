# ==========================================
# 1. IDENTITY & ACCESS MANAGEMENT
# ==========================================
module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  github_repo  = var.github_repo
  
  create_eks_iam_role  = var.create_eks_iam_role
  create_node_iam_role = var.create_node_iam_role
  tags                 = var.tags
}

# ==========================================
# 2. NETWORKING LAYER (Provision 2 VPCs)
# ==========================================
module "vpcs" {
  source   = "./modules/networking"
  # Iterate over var.vpcs (expected keys: "gateway" and "backend")
  for_each = var.vpcs 

  project_name         = var.project_name
  vpc_name             = each.key
  vpc_cidr             = each.value.cidr
  public_subnet_count  = each.value.public_subnet_count
  private_subnet_count = each.value.private_subnet_count
  enable_nat_gateway   = each.value.enable_nat_gateway
  tags                 = var.tags
}

# ==========================================
# 3. COMPUTE: EKS CLUSTERS (Provision 2 Clusters)
# ==========================================
module "eks" {
  source   = "./modules/eks"
  # Sync with the VPCs provisioned above
  for_each = var.vpcs 

  project_name = var.project_name
  # Resolve cluster name based on locals or map keys
  cluster_name = local.cluster_names[each.key]
  
  # --- DYNAMIC NETWORK BINDING ---
  # Assigns each cluster to its corresponding VPC and private subnets
  vpc_id     = module.vpcs[each.key].vpc_id
  subnet_ids = module.vpcs[each.key].private_subnets

  # Reuse IAM roles from the central IAM module for both clusters
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
  
  # Prevent IAM role duplication within the EKS module
  create_eks_iam_role  = var.create_eks_iam_role
  create_node_iam_role = var.create_node_iam_role

  # General Configuration
  kubernetes_version             = var.kubernetes_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  instance_types                 = var.instance_types
  node_capacity_type             = var.node_capacity_type
  scaling_config                 = var.scaling_config
  
  tags = var.tags
}

# ==========================================
# 4. CONNECTIVITY: PEERING & ROUTING
# ==========================================
resource "aws_vpc_peering_connection" "this" {
  for_each = local.vpc_peerings

  # Establish dynamic peering between source and destination VPCs
  vpc_id      = module.vpcs[each.value.source_key].vpc_id
  peer_vpc_id = module.vpcs[each.value.dest_key].vpc_id
  auto_accept = true

  tags = merge(var.tags, { Name = each.value.name })
}

resource "aws_route" "peering_routes" {
  for_each = local.vpc_peerings

  # Inject route into the source VPC private route table pointing to the destination CIDR
  route_table_id            = module.vpcs[each.value.source_key].private_route_table_ids[0]
  destination_cidr_block    = module.vpcs[each.value.dest_key].vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id
}