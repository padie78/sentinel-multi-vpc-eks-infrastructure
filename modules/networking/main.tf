# ==========================================
# 1. EXTERNAL DATA SOURCES
# ==========================================
data "aws_availability_zones" "available" {
  state = local.az_state_filter
}

# ==========================================
# 2. VIRTUAL PRIVATE CLOUD (VPC)
# ==========================================
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(local.common_tags, { Name = local.names.vpc })
}

# ==========================================
# 3. SUBNET LAYERING
# ==========================================

# Public Subnets (For IGW and NAT Gateways)
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    local.eks_public_tags,
    { Name = local.public_subnet_names[count.index] }
  )
}

# Private Subnets (For EKS Worker Nodes)
resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.public_subnet_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    local.eks_private_tags,
    { Name = local.private_subnet_names[count.index] }
  )
}

# ==========================================
# 4. INTERNET CONNECTIVITY
# ==========================================

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = local.names.igw })
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags   = merge(local.common_tags, { Name = local.names.nat_eip })
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  tags          = merge(local.common_tags, { Name = local.names.nat })

  depends_on = [aws_internet_gateway.this]
}

# ==========================================
# 5. ROUTING INFRASTRUCTURE
# ==========================================

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = local.names.public_rt })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.public_dest_cidr
  gateway_id             = aws_internet_gateway.this.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = local.names.private_rt })
}

resource "aws_route" "private_nat" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.private_dest_cidr
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

# ==========================================
# 6. ROUTE TABLE ASSOCIATIONS
# ==========================================

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}