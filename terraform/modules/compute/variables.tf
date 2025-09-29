variable "ami_id" {
  description = "AMI ID for all EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "bastion_subnet_id" {
  description = "Subnet ID for bastion host (public)"
  type        = string
}

variable "frontend_subnet_id" {
  description = "Subnet ID for frontend EC2 (private)"
  type        = string
}

variable "backend_subnet_id" {
  description = "Subnet ID for backend EC2 (private)"
  type        = string
}

variable "bastion_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for bastion"
}

variable "frontend_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for frontend"
}

variable "backend_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for backend"
}

variable "bastion_sg_id" {
  description = "Security Group ID for bastion"
  type        = string
}

variable "frontend_sg_id" {
  description = "Security Group ID for frontend"
  type        = string
}

variable "backend_sg_id" {
  description = "Security Group ID for backend"
  type        = string
}

variable "bastion_user_data" {
  description = "User data script for bastion provisioning"
  type        = string
}

variable "frontend_user_data" {
  description = "User data script for frontend provisioning"
  type        = string
}

variable "backend_user_data" {
  description = "User data script for backend provisioning"
  type        = string
}

variable "tags" {
  description = "Common tags for all EC2 resources"
  type        = map(string)
}
