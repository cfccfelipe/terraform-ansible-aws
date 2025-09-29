variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs for public subnets (ALB, Bastion, NAT)"
  validation {
    condition = length(var.public_subnet_cidrs) >= 1
    error_message = "You must define at least one public subnet for NAT and ALB."
  }
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets (frontend, backend, database)"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "nat_subnet_index" {
  description = "Index of the public subnet used for NAT Gateway"
  type        = number
  default     = 0
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway (true in qa and prod)"
  type        = bool
  default     = true
}

variable "enable_vpc_endpoints" {
  description = "Whether to create VPC endpoints for SSM, S3, EC2, etc."
  type        = bool
  default     = true
}

variable "environment" {
  description = "Deployment environment name (e.g., qa, prod)"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
}
