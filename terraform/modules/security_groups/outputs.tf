output "frontend_sg_id" {
  value       = aws_security_group.frontend_sg.id
  description = "Security Group ID for frontend"
}

output "backend_sg_id" {
  value       = aws_security_group.backend_sg.id
  description = "Security Group ID for backend"
}

output "db_sg_id" {
  value       = aws_security_group.db_sg.id
  description = "Security Group ID for database"
}

output "bastion_sg_id" {
  value       = aws_security_group.bastion_sg.id
  description = "Security Group ID for bastion"
}

output "vpc_endpoint_sg_id" {
  description = "Security Group ID for SSM VPC endpoints"
  value       = aws_security_group.vpc_endpoint_sg.id
}

output "alb_sg_id" {
  description = "Security Group ID for the Application Load Balancer"
  value       = aws_security_group.alb_sg.id
}
