variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_user" {
  type        = string
  description = "Database admin username"
}

variable "db_password" {
  type        = string
  description = "Database admin password"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
}

variable "allocated_storage" {
  type        = number
  description = "RDS allocated storage in GB"
}

variable "db_subnet_group_name" {
  type        = string
  description = "Name of the DB subnet group"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for RDS"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for RDS"
}

variable "db_sg_id" {
  type        = string
  description = "Security Group ID for database"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot on RDS deletion (useful for QA)"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Common tags for database resources"
}
