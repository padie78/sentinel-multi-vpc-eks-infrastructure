# --- 1. NETWORKING DINÁMICO ---
module "vpcs" {
  for_each             = var.vpcs
  source               = "./modules/networking"
  vpc_name             = "vpc-${each.key}"
  vpc_cidr             = each.value.cidr
  public_subnet_count  = each.value.public_subnet_count
  private_subnet_count = each.value.private_subnet_count
  enable_nat_gateway   = each.value.enable_nat_gateway
  project_name         = var.project_name
  tags                 = var.tags
}

# --- 2. CONECTIVIDAD: VPC PEERING ---
resource "aws_vpc_peering_connection" "this" {
  for_each = local.vpc_peerings

  vpc_id      = module.vpcs[each.value.source_key].vpc_id
  peer_vpc_id = module.vpcs[each.value.dest_key].vpc_id
  auto_accept = true

  tags = merge(var.tags, {
    Name = "peering-${each.value.source_key}-to-${each.value.dest_key}"
  })
}

# Rutas dinámicas para el Peering (Reemplaza a los bloques manuales gtw_to_bkd y bkd_to_gtw)
resource "aws_route" "peering_routes" {
  for_each = local.vpc_peerings

  # Accedemos a la tabla de ruteo de la VPC origen definida en locals
  route_table_id         = module.vpcs[each.value.source_key].private_route_table_ids[0]
  
  # El destino es el CIDR de la VPC destino definida en locals
  destination_cidr_block = module.vpcs[each.value.dest_key].vpc_cidr_block
  
  # El ID del peering correspondiente a esta conexión
  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.key].id
}

# --- 3. CÓMPUTO: EKS DINÁMICO ---
module "eks" {
  for_each = var.vpcs
  source   = "./modules/eks"

  project_name   = var.project_name
  github_repo    = var.github_repo
  scaling_config = var.scaling_config
  tags           = var.tags

  cluster_name = "eks-${var.project_name}-${each.key}"
  vpc_id       = module.vpcs[each.key].vpc_id
  subnet_ids   = module.vpcs[each.key].private_subnets

  kubernetes_version             = var.kubernetes_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  node_capacity_type             = var.node_capacity_type
  instance_types                 = var.instance_types
  create_eks_iam_role            = var.create_eks_iam_role
  create_node_iam_role           = var.create_node_iam_role
}

# --- 4. SEGURIDAD: REGLAS DE FIREWALL ---
resource "aws_security_group_rule" "cross_vpc_traffic" {
  for_each = local.security_rules

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  description       = each.value.description

  cidr_blocks       = [module.vpcs[each.value.from_vpc].vpc_cidr_block]
  security_group_id = module.eks[each.value.dest_eks].node_security_group_id
}