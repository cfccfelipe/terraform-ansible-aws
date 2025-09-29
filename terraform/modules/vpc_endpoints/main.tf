# ─────────────────────────────────────────────
# VPC Endpoints for SSM (Interface)
# ─────────────────────────────────────────────
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = var.ssm_endpoint_sg_ids
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "ssm-endpoint"
    Role = "ssm"
  })
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = var.ssm_endpoint_sg_ids
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "ssmmessages-endpoint"
    Role = "ssm"
  })
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = var.ssm_endpoint_sg_ids
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "ec2messages-endpoint"
    Role = "ssm"
  })
}
