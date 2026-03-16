# ==========================================
# NETWORKING MODULE OUTPUTS
# Exports resource IDs and attributes for cross-module integration
# ==========================================

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block associated with the created VPC"
  value       = aws_vpc.this.cidr_block
}

output "private_subnets" {
  description = "List of IDs for the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "List of IDs for the public subnets"
  value       = aws_subnet.public[*].id
}

# ------------------------------------------------------------------
# ROUTING OUTPUTS
# Wrapped in explicit lists to facilitate resource iteration (count/for_each)
# ------------------------------------------------------------------

output "private_route_table_ids" {
  description = "List of IDs for the private route tables"
  value       = [aws_route_table.private.id]
}

output "public_route_table_ids" {
  description = "List of IDs for the public route tables"
  value       = [aws_route_table.public.id]
}

# ------------------------------------------------------------------
# CONNECTIVITY OUTPUTS
# ------------------------------------------------------------------

output "nat_gateway_ip" {
  description = "The public IP address of the NAT Gateway (if enabled)"
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}
