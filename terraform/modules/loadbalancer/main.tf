# ─────────────────────────────────────────────
# Application Load Balancer
# ─────────────────────────────────────────────
resource "aws_lb" "main" {
  name               = "${var.name}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.alb_sg_id]

  tags = merge(var.tags, {
    Name       = "${var.name}-alb"
    Role       = "loadbalancer"
    CostCenter = "lab"
    Tier       = "low-cost"
  })
}

# ─────────────────────────────────────────────
# Target Groups
# ─────────────────────────────────────────────
resource "aws_lb_target_group" "frontend_tg" {
  name        = "${var.name}-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "${var.name}-backend-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ─────────────────────────────────────────────
# Listener HTTP (puerto 80)
# ─────────────────────────────────────────────
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  # Acción por defecto → 404 Not Found
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# ─────────────────────────────────────────────
# Listener Rules
# ─────────────────────────────────────────────
# Regla para backend (/api/*)
resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# Regla para frontend (catch-all /*)
resource "aws_lb_listener_rule" "frontend_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

# ─────────────────────────────────────────────
# Target Group Attachments
# ─────────────────────────────────────────────
# Adjuntar instancias al frontend
resource "aws_lb_target_group_attachment" "frontend_attachment" {
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = var.frontend_instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "backend_attachment" {
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = var.backend_instance_id
  port             = 80
}
