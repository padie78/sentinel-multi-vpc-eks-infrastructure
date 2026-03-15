output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block de la VPC"
  value       = aws_vpc.this.cidr_block
}

output "private_subnets" {
  description = "Lista de IDs de las subnets privadas"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "Lista de IDs de las subnets públicas"
  value       = aws_subnet.public[*].id
}

# Usamos una lista explícita para que el 'count' en las rutas de Peering funcione
output "private_route_table_ids" {
  description = "IDs de las tablas de rutas privadas (formato lista para iteración)"
  value       = [aws_route_table.private.id]
}

output "public_route_table_ids" {
  description = "IDs de las tablas de rutas públicas"
  value       = [aws_route_table.public.id]
}

output "nat_gateway_ip" {
  description = "IP pública del NAT Gateway"
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}

