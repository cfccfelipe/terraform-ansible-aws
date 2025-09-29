# ─────────────────────────────────────────────
# Availability Zones
# ─────────────────────────────────────────────
data "aws_availability_zones" "available" {}

# ─────────────────────────────────────────────
# VPC
# ─────────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "main-vpc"
  })
}

# ─────────────────────────────────────────────
# Internet Gateway
# ─────────────────────────────────────────────
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "main-igw"
  })
}

# ─────────────────────────────────────────────
# Public Subnets
# ─────────────────────────────────────────────
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, {
    Name    = "public-subnet-${count.index}"
    Tier    = "public"
    Purpose = "alb,bastion,nat"
  })
}

# ─────────────────────────────────────────────
# Private Subnets
# ─────────────────────────────────────────────
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, {
    Name    = "private-subnet-${count.index}"
    Tier    = "private"
    Purpose = "frontend,backend,rds"
  })
}

# ─────────────────────────────────────────────
# Elastic IP for NAT Gateway (conditional)
# ─────────────────────────────────────────────
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "nat-eip"
    Role = "network"
  })
}

# ─────────────────────────────────────────────
# NAT Gateway (conditional)
# ─────────────────────────────────────────────
resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[var.nat_subnet_index].id

  tags = merge(var.tags, {
    Name = "nat-gateway"
  })
}

# ─────────────────────────────────────────────
# Route Table for Public Subnets
# ─────────────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ─────────────────────────────────────────────
# Route Table for Private Subnets (conditional NAT)
# ─────────────────────────────────────────────
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.enable_nat_gateway ? aws_nat_gateway.nat[0].id : null
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

