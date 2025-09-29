variable "vpc_id" {
  description = "VPC ID for all security groups"
  type        = string
}

variable "tags" {
  description = "Common tags for all SG resources"
  type        = map(string)
}

variable "trusted_ip_cidr" {
  description = "Your public IP in CIDR format for SSH access"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}
