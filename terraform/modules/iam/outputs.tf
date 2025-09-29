output "frontend_instance_profile_name" {
  description = "IAM instance profile name for frontend EC2"
  value       = aws_iam_instance_profile.frontend.name
}

output "frontend_role_name" {
  description = "IAM role name for frontend EC2"
  value       = aws_iam_role.frontend.name
}

output "frontend_role_arn" {
  description = "IAM role ARN for frontend EC2"
  value       = aws_iam_role.frontend.arn
}

output "backend_instance_profile_name" {
  description = "IAM instance profile name for backend EC2"
  value       = aws_iam_instance_profile.backend.name
}

output "backend_role_name" {
  description = "IAM role name for backend EC2"
  value       = aws_iam_role.backend.name
}

output "backend_role_arn" {
  description = "IAM role ARN for backend EC2"
  value       = aws_iam_role.backend.arn
}

output "bastion_instance_profile_name" {
  description = "IAM instance profile name for bastion EC2"
  value       = aws_iam_instance_profile.bastion.name
}

output "bastion_role_name" {
  description = "IAM role name for bastion EC2"
  value       = aws_iam_role.bastion.name
}

output "bastion_role_arn" {
  description = "IAM role ARN for bastion EC2"
  value       = aws_iam_role.bastion.arn
}
