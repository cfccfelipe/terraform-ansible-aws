resource "aws_s3_bucket" "ssm_transfer" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name        = var.bucket_name
    Purpose     = "ssm-transfer"
    CostCenter  = "infra"
    Tier        = "shared"
  })
}

resource "aws_s3_bucket_public_access_block" "ssm_transfer_block" {
  bucket = aws_s3_bucket.ssm_transfer.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "ssm_transfer_policy" {
  bucket = aws_s3_bucket.ssm_transfer.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSSMTransferFromAccountRoles"
        Effect    = "Allow"
        Principal = "*"
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource  = "${aws_s3_bucket.ssm_transfer.arn}/*"
        Condition = {
          StringEquals = {
            "aws:PrincipalAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}
