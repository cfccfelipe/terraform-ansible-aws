variable "region" {
  description = "AWS region for endpoint resolution"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where endpoints will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for endpoint placement"
  type        = list(string)
}

variable "ssm_endpoint_sg_ids" {
  description = "Security group IDs to attach to the endpoints"
  type        = list(string)
}

variable "tags" {
  description = "Common tags to apply to endpoint resources"
  type        = map(string)
}
