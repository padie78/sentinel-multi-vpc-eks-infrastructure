# ==========================================
# NETWORKING MODULE OUTPUTS
# Exports resource IDs and attributes for cross-module integration
# ==========================================

output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the created VPC"
}

output "vpc_cidr_block" {
  value       = aws_vpc.this.cidr_block
  description = "The CIDR block associated with the created VPC"
}

output "private_subnets" {
  value       = aws_subnet.private[*].id
  description = "List of IDs for the private subnets"  
}

output "public_subnets" {  
  value       = aws_subnet.public[*].id
  description = "List of IDs for the public subnets"
}

# ------------------------------------------------------------------
# ROUTING OUTPUTS
# Wrapped in explicit lists to facilitate resource iteration (count/for_each)
# ------------------------------------------------------------------

output "private_route_table_ids" {
  value       = [aws_route_table.private.id]
  description = "List of IDs for the private route tables"
}

output "public_route_table_ids" {  
  value       = [aws_route_table.public.id]
  description = "List of IDs for the public route tables"
}

# ------------------------------------------------------------------
# CONNECTIVITY OUTPUTS
# ------------------------------------------------------------------

output "nat_gateway_ip" {
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
  description = "The public IP address of the NAT Gateway (if enabled)"
}
