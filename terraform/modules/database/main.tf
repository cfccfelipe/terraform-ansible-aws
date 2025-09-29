# ─────────────────────────────────────────────
# DB Subnet Group (usando subnets ya creadas)
# ─────────────────────────────────────────────
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Role = "database"
    Tier = "low-cost"
  })
}

# ─────────────────────────────────────────────
# RDS Instance (MySQL)
# ─────────────────────────────────────────────
resource "aws_db_instance" "mysql" {
  engine                 = "mysql"
  engine_version         = "8.0"
  db_name                = "movie_db"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = "gp2"
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.db_sg_id]

  multi_az               = false
  skip_final_snapshot    = var.skip_final_snapshot
  deletion_protection    = false
  publicly_accessible    = false

  tags = merge(var.tags, {
    Role        = "database"
    CostCenter  = "lab"
    Tier        = "low-cost"
  })
}
