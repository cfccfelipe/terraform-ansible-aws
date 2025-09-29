# ─────────────────────────────────────────────
### General Configuration
# ─────────────────────────────────────────────
environment = "qa"
region      = "us-east-1"

tags = {
  Project     = "terraform-ansible-aws"
  Environment = "qa"
  Owner       = "felipe"
  CostCenter  = "lab"
  Tier        = "low-cost"
}
# ─────────────────────────────────────────────
### Network Configuration
# ─────────────────────────────────────────────
vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24", # us-east-1a
  "10.0.2.0/24"  # us-east-1b (solo para cumplir con ALB)
]


private_subnet_cidrs = [
  "10.0.101.0/24", # Frontend       - us-east-1a
  "10.0.102.0/24", # Backend        - us-east-1a
  "10.0.103.0/24"  # Database       - us-east-1b
]


trusted_ip_cidr = "999.999.99.999/32"
# ─────────────────────────────────────────────
### EC2 Configuration
# ─────────────────────────────────────────────
ami_id        = "ami-0dfcb1ef8550277af"
instance_type = "t3.micro"

# IAM roles and instance profiles
frontend_role_name              = "ec2-frontend-role"
backend_role_name               = "ec2-backend-role"
bastion_role_name               = "ec2-bastion-role"

frontend_instance_profile_name = "ec2-frontend-profile"
backend_instance_profile_name  = "ec2-backend-profile"
bastion_instance_profile_name  = "ec2-bastion-profile"

# IAM policies
frontend_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
]

backend_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
  "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
]

bastion_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  "arn:aws:iam::aws:policy/AmazonS3FullAccess"
]


### User Data Scripts

frontend_user_data = <<EOF
#!/bin/bash
set -e
echo "[frontend] Updating system..."
yum update -y
echo "[frontend] Installing dependencies..."
yum install -y git nodejs curl amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
echo "[frontend] Cloning UI repo..."
cd /opt
git clone https://github.com/aljoveza/devops-rampup.git || { echo "Repo clone failed"; exit 1; }
echo "[frontend] Installing Node.js packages..."
cd devops-rampup/movie-analyst-ui
npm install || { echo "npm install failed"; exit 1; }
echo "[frontend] Setup complete."
EOF

backend_user_data = <<EOF
#!/bin/bash
set -e
echo "[backend] Updating system..."
yum update -y
echo "[backend] Installing dependencies..."
yum install -y python3 curl git mysql amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
echo "[backend] Cloning API repo..."
cd /opt
git clone https://github.com/aljoveza/devops-rampup.git || { echo "Repo clone failed"; exit 1; }
echo "[backend] Installing Python packages..."
cd devops-rampup/movie-analyst-api
pip3 install -r requirements.txt || { echo "pip install failed"; exit 1; }
echo "[backend] Setup complete."
EOF

bastion_user_data = <<EOF
#!/bin/bash
set -e
echo "[bastion] Detecting Linux distribution..."
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=$ID
else
  DISTRO="unknown"
fi
echo "[bastion] Detected distro: $DISTRO"

echo "[bastion] Ensuring SSM Agent is installed and running..."
if ! command -v amazon-ssm-agent >/dev/null 2>&1; then
  if command -v snap >/dev/null 2>&1; then
    snap install amazon-ssm-agent --classic || true
  fi
fi
systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent

echo "[bastion] Installing Ansible and curl..."
case "$DISTRO" in
  amzn|centos|rhel)
    yum update -y
    yum install -y python3 python3-pip curl unzip
    pip3 install ansible
    ;;
  ubuntu|debian)
    apt update -y
    apt install -y python3 python3-pip curl unzip
    pip3 install ansible
    ;;
  *)
    echo "[bastion] Unsupported distro: $DISTRO" >&2
    ;;
esac

echo "[bastion] Verifying installations..."
ansible --version || echo "[bastion] Ansible installation failed"
curl --version || echo "[bastion] Curl installation failed"
amazon-ssm-agent --version || echo "[bastion] SSM Agent not found"
echo "[bastion] Setup complete. Ready to receive SSM instructions."
EOF
# ─────────────────────────────────────────────
### RDS Configuration
# ─────────────────────────────────────────────
db_instance_class     = "db.t3.micro"
allocated_storage     = 20
db_name               = "movieanalytics"
db_user               = "admin"
db_password           = "securepass123"
db_subnet_group_name  = "qa-db-subnet-group"
