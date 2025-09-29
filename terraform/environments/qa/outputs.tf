# ─────────────────────────────────────────────
# Bastion EC2 (SSM-only)
# ─────────────────────────────────────────────
output "ansible_bastion_instance_id" {
  description = "Bastion EC2 instance ID for Ansible SSM"
  value       = module.compute.bastion_instance_id
}

output "bastion_private_ip" {
  description = "Bastion EC2 private IP"
  value       = module.compute.bastion_private_ip
}

output "bastion_public_ip" {
  description = "Bastion EC2 public IP"
  value       = module.compute.bastion_public_ip
}

# ─────────────────────────────────────────────
# Frontend EC2
# ─────────────────────────────────────────────
output "ansible_frontend_instance_id" {
  description = "Frontend EC2 instance ID for Ansible SSM"
  value       = module.compute.frontend_instance_id
}

output "frontend_private_ip" {
  description = "Frontend EC2 private IP"
  value       = module.compute.frontend_private_ip
}

# ─────────────────────────────────────────────
# Backend EC2
# ─────────────────────────────────────────────
output "ansible_backend_instance_id" {
  description = "Backend EC2 instance ID for Ansible SSM"
  value       = module.compute.backend_instance_id
}

output "backend_private_ip" {
  description = "Backend EC2 private IP"
  value       = module.compute.backend_private_ip
}

# ─────────────────────────────────────────────
# RDS Database
# ─────────────────────────────────────────────
output "db_endpoint" {
  description = "RDS endpoint for database connection"
  value       = module.database.db_endpoint
}

output "db_port" {
  description = "RDS port for database connection"
  value       = module.database.db_port
}

# ─────────────────────────────────────────────
# SSM File Transfer Bucket
# ─────────────────────────────────────────────
output "ansible_aws_ssm_bucket_name" {
  description = "S3 bucket name used for SSM file transfers"
  value       = module.ssm_transfer_bucket.ssm_bucket_name
}

output "ansible_aws_ssm_bucket_endpoint_url" {
  description = "S3 endpoint URL used for SSM file transfers"
  value       = module.ssm_transfer_bucket.ssm_bucket_endpoint_url
}

output "ansible_aws_region" {
  description = "AWS region used for SSM connections"
  value       = var.region
}

# ─────────────────────────────────────────────
# Load Balancer
# ─────────────────────────────────────────────
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.loadbalancer.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = module.loadbalancer.alb_zone_id
}

# ─────────────────────────────────────────────
# VPC Endpoints
# ─────────────────────────────────────────────
output "ssm_endpoint_id" {
  description = "VPC Endpoint ID for SSM"
  value       = module.vpc_endpoints.ssm_endpoint_id
}

output "ssmmessages_endpoint_id" {
  description = "VPC Endpoint ID for SSMMessages"
  value       = module.vpc_endpoints.ssmmessages_endpoint_id
}

output "ec2messages_endpoint_id" {
  description = "VPC Endpoint ID for EC2Messages"
  value       = module.vpc_endpoints.ec2messages_endpoint_id
}

output "ssm_endpoint_dns" {
  description = "Private DNS name for SSM endpoint"
  value       = module.vpc_endpoints.ssm_endpoint_dns
}
