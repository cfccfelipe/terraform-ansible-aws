output "ssm_bucket_name" {
  description = "Nombre del bucket S3 para transferencias SSM"
  value       = aws_s3_bucket.ssm_transfer.bucket
}

output "ssm_bucket_endpoint_url" {
  description = "Endpoint S3 para el bucket (usado por Ansible)"
  value       = "https://s3.${var.region}.amazonaws.com"
}
