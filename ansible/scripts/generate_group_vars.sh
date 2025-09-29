#!/bin/bash
set -euo pipefail

echo "🔧 Generating group_vars/all.yml from outputs.json..."

mkdir -p ../group_vars
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
# Extract values
# ─────────────────────────────────────────────
RDS_ENDPOINT=$(get_value "db_endpoint")
RDS_PORT=$(get_value "db_port")
DB_USER=$(get_value "db_user")
DB_PASSWORD=$(get_value "db_password")
DB_NAME=$(get_value "db_name")
REGION=$(get_value "ansible_aws_region")
BUCKET_NAME=$(get_value "ansible_aws_ssm_bucket_name")
BACKEND_URL=$(get_value "backend_url")

# ─────────────────────────────────────────────
# Write group_vars file
# ─────────────────────────────────────────────
cat > ../group_vars/all.yml <<EOF
# Interpreter and SSM configuration
ansible_connection: aws_ssm
ansible_aws_ssm_bucket_name: $BUCKET_NAME
ansible_aws_ssm_s3_addressing_style: virtual
ansible_aws_region: $REGION

# Database
rds_endpoint: $RDS_ENDPOINT
rds_port: $RDS_PORT
db_user: $DB_USER
db_name: $DB_NAME
db_password: $DB_PASSWORD

# Backend
backend_url: $BACKEND_URL
EOF

echo "✅ group_vars/all.yml generated successfully."
