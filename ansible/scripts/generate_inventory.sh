#!/bin/bash
set -euo pipefail

echo "🔍 Generating dynamic inventory..."

mkdir -p ../inventory
OUTPUTS_FILE="../outputs.json"

get_value() {
  awk -v key="$1" '
    $0 ~ "\""key"\"" {found=1}
    found && /"value"/ {
      match($0, /"value": ?"([^"]+)"/, arr)
      print arr[1]
      exit
    }
  ' "$OUTPUTS_FILE"
}

# ─────────────────────────────────────────────
# Extract required values
# ─────────────────────────────────────────────
FRONTEND_ID=$(get_value "ansible_frontend_instance_id")
BACKEND_ID=$(get_value "ansible_backend_instance_id")
BASTION_ID=$(get_value "ansible_bastion_instance_id")
REGION=$(get_value "ansible_aws_region")
BUCKET_NAME=$(get_value "ansible_aws_ssm_bucket_name")
DB_HOST=$(get_value "db_endpoint")
DB_PORT=$(get_value "db_port")
DB_USER=$(get_value "db_user")
DB_NAME=$(get_value "db_name")
DB_PASSWORD=$(get_value "db_password")
BACKEND_URL=$(get_value "backend_url")

# ─────────────────────────────────────────────
# Write inventory file
# ─────────────────────────────────────────────
cat > ../inventory/hosts.ini <<EOF
[frontend]
$FRONTEND_ID

[backend]
$BACKEND_ID

[bastion]
$BASTION_ID

[all:vars]
# Interpreter and SSM configuration
ansible_connection=aws_ssm
ansible_aws_ssm_bucket_name=$BUCKET_NAME
ansible_aws_ssm_s3_addressing_style=virtual
ansible_aws_region=$REGION

# Database
rds_endpoint=$DB_HOST
rds_port=$DB_PORT
db_user=$DB_USER
db_name=$DB_NAME
db_password=$DB_PASSWORD

# Backend
backend_url=$BACKEND_URL
EOF

echo "✅ Inventory generated at ../inventory/hosts.ini"
