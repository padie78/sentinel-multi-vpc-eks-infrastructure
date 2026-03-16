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
# 2. NETWORKING LAYER (Crea 2 VPCs)
# ==========================================
module "vpcs" {
  source   = "./modules/networking"
  # Iteramos sobre var.vpcs (debe contener "gateway" y "backend")
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
# 3. COMPUTE: EKS CLUSTERS (Crea 2 Clusters)
# ==========================================
module "eks" {
  source   = "./modules/eks"
  # Sincronizamos con las VPCs creadas arriba
  for_each = var.vpcs 

  project_name = var.project_name
  # Usamos el nombre del cluster según el local o simplemente el key
  cluster_name = local.cluster_names[each.key]
  
  # --- VINCULACIÓN DINÁMICA ---
  # Cada cluster se mete en su VPC correspondiente usando el match de llaves
  vpc_id     = module.vpcs[each.key].vpc_id
  subnet_ids = module.vpcs[each.key].private_subnets

  # Reutilizamos los roles del módulo IAM para ambos clusters
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
  
  # Evitamos duplicidad de roles IAM dentro del módulo
  create_eks_iam_role  = false 
  create_node_iam_role = false

  # Configuración general
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
resource "aws_vpc_peering_connection" "this" {
  for_each = local.vpc_peerings

  # Conecta la VPC de origen con la de destino dinámicamente
  vpc_id      = module.vpcs[each.value.source_key].vpc_id
  peer_vpc_id = module.vpcs[each.value.dest_key].vpc_id
  auto_accept = true

  tags = merge(var.tags, { Name = each.value.name })
}

resource "aws_route" "peering_routes" {
  for_each = local.vpc_peerings

  # Agregamos la ruta en la tabla privada de la VPC origen hacia el CIDR de la destino
  route_table_id            = module.vpcs[each.value.source_key].private_route_table_ids[0]
  destination_cidr_block    = module.vpcs[each.value.dest_key].vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id
}