# ─────────────────────────────────────────────
#### General Configuration
# ─────────────────────────────────────────────
variable "environment" {
  description = "Deployment environment name (qa or prod)"
  type        = string
}

variable "region" {
  description = "AWS region for deployment and S3 bucket for SSM transfers"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
# ─────────────────────────────────────────────
### Network Configuration
# ─────────────────────────────────────────────
variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets (ALB, bastion)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets (frontend, backend, database)"
  type        = list(string)
}

variable "trusted_ip_cidr" {
  description = "Your public IP in CIDR format for SSM or SSH access"
  type        = string
}
# ─────────────────────────────────────────────
### EC2 Configuration
# ─────────────────────────────────────────────
variable "ami_id" {
  description = "Amazon Linux 2 AMI with SSM agent"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for all components"
  type        = string
}

# IAM roles and instance profiles
variable "frontend_role_name" {
  description = "IAM role name for frontend EC2 instances"
  type        = string
}

variable "backend_role_name" {
  description = "IAM role name for backend EC2 instances"
  type        = string
}

variable "bastion_role_name" {
  description = "IAM role name for bastion EC2 instance"
  type        = string
}

variable "frontend_instance_profile_name" {
  description = "Instance profile name for frontend EC2"
  type        = string
}

variable "backend_instance_profile_name" {
  description = "Instance profile name for backend EC2"
  type        = string
}

variable "bastion_instance_profile_name" {
  description = "Instance profile name for bastion EC2"
  type        = string
}

# IAM policies
variable "frontend_policy_arns" {
  description = "List of IAM policy ARNs for frontend role"
  type        = list(string)
}

variable "backend_policy_arns" {
  description = "List of IAM policy ARNs for backend role"
  type        = list(string)
}

variable "bastion_policy_arns" {
  description = "List of IAM policy ARNs for bastion role"
  type        = list(string)
}

# User data scripts
variable "frontend_user_data" {
  description = "User data script for frontend setup"
  type        = string
}

variable "backend_user_data" {
  description = "User data script for backend setup"
  type        = string
}

variable "bastion_user_data" {
  description = "User data script for bastion setup"
  type        = string
}
# ─────────────────────────────────────────────
### RDS Configuration
# ─────────────────────────────────────────────
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database admin username"
  type        = string
}

variable "db_password" {
  description = "Database admin password"
  type        = string
}

variable "db_subnet_group_name" {
  description = "RDS subnet group name"
  type        = string
}
