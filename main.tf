# ----------------------------------------------------------------              
# 1. VARIABLES GLOBALES                                                         
# ----------------------------------------------------------------              
variable "project_name" {
  type    = string
  default = "sentinel"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# ----------------------------------------------------------------              
# 2. NETWORKING: CREACIÓN DE VPCS AISLADAS                                      
# ----------------------------------------------------------------              

module "vpc_gateway" {
  source             = "./modules/networking"
  vpc_name           = "vpc-gateway"
  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.10.0/24", "10.0.11.0/24"]
  enable_nat_gateway = true
  project_name       = var.project_name
}

module "vpc_backend" {
  source             = "./modules/networking"
  vpc_name           = "vpc-backend"
  vpc_cidr           = "10.1.0.0/16"
  public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets    = ["10.1.10.0/24", "10.1.11.0/24"]
  enable_nat_gateway = true
  project_name       = var.project_name
}

# ----------------------------------------------------------------              
# 3. CONECTIVIDAD: VPC PEERING Y RUTAS                                          
# ----------------------------------------------------------------              

resource "aws_vpc_peering_connection" "intra_sentinel" {
  vpc_id      = module.vpc_gateway.vpc_id
  peer_vpc_id = module.vpc_backend.vpc_id
  auto_accept = true

  tags = {
    Name    = "peering-gateway-to-backend"
    Project = var.project_name
  }
}

resource "aws_route" "gtw_to_bkd" {
  count                     = length(module.vpc_gateway.private_route_table_ids)
  route_table_id            = module.vpc_gateway.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc_backend.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.intra_sentinel.id
}

resource "aws_route" "bkd_to_gtw" {
  count                     = length(module.vpc_backend.private_route_table_ids)
  route_table_id            = module.vpc_backend.private_route_table_ids[count.index]
  destination_cidr_block    = module.vpc_gateway.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.intra_sentinel.id
}

# ----------------------------------------------------------------              
# 4. CÓMPUTO: CLUSTERS EKS                                                       
# ----------------------------------------------------------------              

module "eks_gateway" {
  source       = "./modules/eks"
  cluster_name = "eks-sentinel-gateway"
  vpc_id       = module.vpc_gateway.vpc_id
  subnet_ids   = module.vpc_gateway.private_subnets
  project_name = var.project_name
}

module "eks_backend" {
  source       = "./modules/eks"
  cluster_name = "eks-sentinel-backend"
  vpc_id       = module.vpc_backend.vpc_id
  subnet_ids   = module.vpc_backend.private_subnets
  project_name = var.project_name
}

# ----------------------------------------------------------------              
# 5. SEGURIDAD: REGLAS DE FIREWALL (Security Groups)                            
# ----------------------------------------------------------------              

resource "aws_security_group_rule" "allow_gateway_traffic" {
  description       = "Permitir trafico desde la VPC Gateway hacia los nodos Backend"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [module.vpc_gateway.vpc_cidr_block]
  security_group_id = module.eks_backend.node_security_group_id
}