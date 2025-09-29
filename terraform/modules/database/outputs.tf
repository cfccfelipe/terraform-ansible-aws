output "db_endpoint" {
  description = "RDS endpoint for MySQL connection"
  value       = aws_db_instance.mysql.endpoint
}

output "db_port" {
  description = "Port on which the MySQL database is listening"
  value       = aws_db_instance.mysql.port
}
