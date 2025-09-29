# ─────────────────────────────────────────────
# Load Balancer SG – ALB for frontend access
# ─────────────────────────────────────────────
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow public HTTP/HTTPS access to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name    = "alb-sg"
    Role    = "loadbalancer"
    Purpose = "public-ingress"
    Tier    = "low-cost"
  })
}

# ─────────────────────────────────────────────
# Frontend SG – solo acepta tráfico del ALB
# ─────────────────────────────────────────────
resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Allow traffic from ALB to frontend"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name    = "frontend-sg"
    Role    = "frontend"
    Purpose = "ui-access"
  })
}

resource "aws_security_group_rule" "frontend_ingress_ui" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.frontend_sg.id
}

# ─────────────────────────────────────────────
# Backend SG – solo acepta tráfico del ALB y DB
# ─────────────────────────────────────────────
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Allow API traffic from ALB and DB access from RDS"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name    = "backend-sg"
    Role    = "backend"
    Purpose = "api-access,mysql-from-db"
  })
}

resource "aws_security_group_rule" "backend_ingress_api" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.backend_sg.id
}


# ─────────────────────────────────────────────
# DB SG – MySQL (3306) access from backend
# ─────────────────────────────────────────────
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow MySQL access from backend EC2"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name    = "db-sg"
    Role    = "database"
    Purpose = "mysql-access"
    Tier    = "low-cost"
  })
}

resource "aws_security_group_rule" "db_ingress_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_sg.id
  security_group_id        = aws_security_group.db_sg.id
}

# ─────────────────────────────────────────────
# Bastion SG – SSM-only access
# ─────────────────────────────────────────────
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "SSM-only access (no SSH)"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name    = "bastion-sg"
    Role    = "bastion"
    Purpose = "ssm-only"
    Tier    = "low-cost"
  })
}

# ─────────────────────────────────────────────
# VPC Endpoint SG – SSM Interface Endpoints
# ─────────────────────────────────────────────
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-ssm-sg"
  description = "Allow EC2 instances to reach SSM endpoints via HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS from private subnets"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name    = "vpc-endpoint-ssm-sg"
    Role    = "ssm-endpoint"
    Purpose = "ssm-interface-access"
    Tier    = "low-cost"
  })
}

