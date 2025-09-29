output "bastion_instance_id" {
  value       = aws_instance.bastion.id
  description = "Instance ID of the bastion EC2"
}

output "bastion_private_ip" {
  value       = aws_instance.bastion.private_ip
  description = "Private IP of the bastion EC2"
}

output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Public IP of the bastion EC2"
}

output "frontend_instance_id" {
  value       = aws_instance.frontend.id
  description = "Instance ID of the frontend EC2"
}

output "frontend_private_ip" {
  value       = aws_instance.frontend.private_ip
  description = "Private IP of the frontend EC2"
}

output "backend_instance_id" {
  value       = aws_instance.backend.id
  description = "Instance ID of the backend EC2"
}

output "backend_private_ip" {
  value       = aws_instance.backend.private_ip
  description = "Private IP of the backend EC2"
}
