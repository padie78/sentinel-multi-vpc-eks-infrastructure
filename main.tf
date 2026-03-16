# ==========================================
# 1. IDENTITY & ACCESS MANAGEMENT
# ==========================================
module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  github_repo  = var.github_repo
  
  # Forzamos la creación en IAM, pero sin etiquetas (dentro del módulo)
  create_eks_iam_role  = var.create_eks_iam_role
  create_node_iam_role = var.create_node_iam_role
  tags                 = var.tags
}

# ==========================================
# 2. NETWORKING LAYER
# ==========================================
module "vpcs" {
  source   = "./modules/networking"
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
# 3. COMPUTE: EKS CLUSTERS
# ==========================================
module "eks" {
  source   = "./modules/eks"
  for_each = var.vpcs

  project_name = var.project_name
  cluster_name = local.cluster_names[each.key]
  
  # Network Integration
  vpc_id     = module.vpcs[each.key].vpc_id
  subnet_ids = module.vpcs[each.key].private_subnets

  # --- EL CAMBIO CRÍTICO AQUÍ ---
  # Pasamos los ARNs del módulo IAM
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
  
  # Le decimos al módulo de EKS que NO intente crear roles internos
  # Asegúrate de que en tu modules/eks/main.tf uses estas variables
  # para setear 'create_iam_role = false'
  create_eks_iam_role  = false 
  create_node_iam_role = false
  # ------------------------------

  # EKS Configuration
  kubernetes_version             = var.kubernetes_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  instance_types                 = var.instance_types
  node_capacity_type             = var.node_capacity_type
  scaling_config                 = var.scaling_config
  
  tags = var.tags
}

# ==========================================
# 4. CONNECTIVITY: PEERING & SECURITY
# ==========================================
# (Se mantiene igual, ya que depende de los IDs generados arriba)
# resource "aws_vpc_peering_connection" "this" {
#   for_each = local.vpc_peerings

#   vpc_id      = module.vpcs[each.value.source_key].vpc_id
#   peer_vpc_id = module.vpcs[each.value.dest_key].vpc_id
#   auto_accept = true

#   tags = merge(var.tags, { Name = each.value.name })
# }

# resource "aws_route" "peering_routes" {
#   for_each = local.vpc_peerings

#   route_table_id            = module.vpcs[each.value.source_key].private_route_table_ids[0]
#   destination_cidr_block    = module.vpcs[each.value.dest_key].vpc_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id
# }

# resource "aws_security_group_rule" "cross_vpc_traffic" {
#   for_each = local.security_rules

#   type        = each.value.type
#   from_port   = each.value.from_port
#   to_port     = each.value.to_port
#   protocol    = each.value.protocol
#   description = each.value.description
  
#   cidr_blocks       = [module.vpcs[each.value.from_vpc].vpc_cidr_block]
#   security_group_id = module.eks[each.value.dest_eks].node_security_group_id
# }