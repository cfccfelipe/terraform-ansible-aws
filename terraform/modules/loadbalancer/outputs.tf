# ─────────────────────────────────────────────
# Outputs del módulo Load Balancer
# ─────────────────────────────────────────────

output "alb_dns_name" {
  description = "DNS público del Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN del Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_zone_id" {
  description = "Zone ID del ALB (para records en Route53)"
  value       = aws_lb.main.zone_id
}

output "frontend_target_group_arn" {
  description = "ARN del Target Group del frontend"
  value       = aws_lb_target_group.frontend_tg.arn
}

output "frontend_target_group_name" {
  description = "Nombre del Target Group del frontend"
  value       = aws_lb_target_group.frontend_tg.name
}

output "backend_target_group_arn" {
  description = "ARN del Target Group del backend"
  value       = aws_lb_target_group.backend_tg.arn
}

output "backend_target_group_name" {
  description = "Nombre del Target Group del backend"
  value       = aws_lb_target_group.backend_tg.name
}
