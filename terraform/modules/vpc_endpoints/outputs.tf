output "ssm_endpoint_id" {
  description = "ID of the SSM VPC endpoint"
  value       = aws_vpc_endpoint.ssm.id
}

output "ssmmessages_endpoint_id" {
  description = "ID of the SSMMessages VPC endpoint"
  value       = aws_vpc_endpoint.ssmmessages.id
}

output "ec2messages_endpoint_id" {
  description = "ID of the EC2Messages VPC endpoint"
  value       = aws_vpc_endpoint.ec2messages.id
}

output "ssm_endpoint_dns" {
  description = "Private DNS name for the SSM endpoint"
  value       = aws_vpc_endpoint.ssm.dns_entry[0].dns_name
}
