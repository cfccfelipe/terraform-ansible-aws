### IAM Role Names
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


### IAM Instance Profile Names
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

### IAM Policy ARNs
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

### Common Tags
variable "tags" {
  description = "Common tags applied to IAM resources"
  type        = map(string)
}
