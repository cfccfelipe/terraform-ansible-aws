# ─────────────────────────────────────────────
# IAM Assume Role Policy (compartida por EC2)
# ─────────────────────────────────────────────
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ─────────────────────────────────────────────
# IAM Roles por capa
# ─────────────────────────────────────────────
resource "aws_iam_role" "frontend" {
  name               = var.frontend_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = var.tags
}

resource "aws_iam_role" "backend" {
  name               = var.backend_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = var.tags
}

resource "aws_iam_role" "bastion" {
  name               = var.bastion_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = var.tags
}

# ─────────────────────────────────────────────
# IAM Policy Attachments por capa
# ─────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "frontend_policies" {
  for_each   = toset(var.frontend_policy_arns)
  role       = aws_iam_role.frontend.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "backend_policies" {
  for_each   = toset(var.backend_policy_arns)
  role       = aws_iam_role.backend.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "bastion_policies" {
  for_each   = toset(var.bastion_policy_arns)
  role       = aws_iam_role.bastion.name
  policy_arn = each.value
}

# ─────────────────────────────────────────────
# IAM Instance Profiles por capa
# ─────────────────────────────────────────────
resource "aws_iam_instance_profile" "frontend" {
  name = var.frontend_instance_profile_name
  role = aws_iam_role.frontend.name
  tags = var.tags
}

resource "aws_iam_instance_profile" "backend" {
  name = var.backend_instance_profile_name
  role = aws_iam_role.backend.name
  tags = var.tags
}

resource "aws_iam_instance_profile" "bastion" {
  name = var.bastion_instance_profile_name
  role = aws_iam_role.bastion.name
  tags = var.tags
}
