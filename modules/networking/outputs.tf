output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block de la VPC"
  value       = aws_vpc.this.cidr_block
}

output "private_subnets" {
  description = "IDs de las subnets privadas"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "IDs de las subnets públicas"
  value       = aws_subnet.public[*].id
}

output "private_route_table_ids" {
  description = "IDs de las tablas de rutas privadas (necesario para el Peering)"
  value       = [aws_route_table.private.id]
}