# ─────────────────────────────────────────────
# Bastion EC2 (SSM-only)
# ─────────────────────────────────────────────
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.bastion_subnet_id
  iam_instance_profile   = var.bastion_instance_profile_name
  vpc_security_group_ids = [var.bastion_sg_id]
  user_data              = var.bastion_user_data

  tags = merge(var.tags, {
    Name       = "bastion-instance"
    Role       = "bastion"
    Tier       = "low-cost"
    Access     = "ssm-only"
  })
}

# ─────────────────────────────────────────────
# Frontend EC2
# ─────────────────────────────────────────────
resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.frontend_subnet_id
  iam_instance_profile   = var.frontend_instance_profile_name
  vpc_security_group_ids = [var.frontend_sg_id]
  user_data              = var.frontend_user_data

  tags = merge(var.tags, {
    Name       = "frontend-instance"
    Role       = "frontend"
    Tier       = "low-cost"
    CostCenter = "lab"
  })
}

# ─────────────────────────────────────────────
# Backend EC2
# ─────────────────────────────────────────────
resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.backend_subnet_id
  iam_instance_profile   = var.backend_instance_profile_name
  vpc_security_group_ids = [var.backend_sg_id]
  user_data              = var.backend_user_data

  tags = merge(var.tags, {
    Name       = "backend-instance"
    Role       = "backend"
    Tier       = "low-cost"
    CostCenter = "lab"
  })
}
