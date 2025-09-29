variable "name" {
  type        = string
  description = "Name prefix for ALB and related resources (e.g., DNS, target groups, listeners)"
  default     = "movie-alb"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the ALB and its security group will be deployed"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for placing ALB across availability zones"
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all ALB-related resources for governance and cost tracking"
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID to attach to the ALB"
}

variable "internal" {
  type        = bool
  description = "Whether the ALB should be internal (true) or internet-facing (false)"
  default     = false
}

variable "listener_ports" {
  type        = list(number)
  description = "List of ports to expose via ALB listeners (e.g., [80, 443])"
  default     = [80]
}

variable "frontend_instance_id" {
  type = string
}

variable "backend_instance_id" {
  type = string
}
