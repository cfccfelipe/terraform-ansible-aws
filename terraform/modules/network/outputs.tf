output "vpc_id" {
  description = "ID of the main VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "availability_zones" {
  description = "List of AZs used for subnet distribution"
  value       = data.aws_availability_zones.available.names
}

output "public_subnet_ids" {
  description = "List of public subnet IDs across AZs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs across AZs"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway (if enabled)"
  value       = var.enable_nat_gateway ? aws_nat_gateway.nat[0].id : null
}

output "nat_eip" {
  description = "Elastic IP associated with NAT Gateway"
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}

output "public_route_table_id" {
  description = "Route table ID for public subnets"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Route table ID for private subnets"
  value       = aws_route_table.private.id
}


