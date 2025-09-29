### 1. Networking
module "network" {
  source               = "../../modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
  tags                 = var.tags
}

### 2. IAM Roles and Instance Profiles
module "iam" {
  source = "../../modules/iam"

  # Role names por capa
  frontend_role_name = var.frontend_role_name
  backend_role_name  = var.backend_role_name
  bastion_role_name  = var.bastion_role_name

  # Instance profile names por capa
  frontend_instance_profile_name = var.frontend_instance_profile_name
  backend_instance_profile_name  = var.backend_instance_profile_name
  bastion_instance_profile_name  = var.bastion_instance_profile_name

  # Policy ARNs por capa
  frontend_policy_arns = var.frontend_policy_arns
  backend_policy_arns  = var.backend_policy_arns
  bastion_policy_arns  = var.bastion_policy_arns

  # Common tags
  tags = var.tags
}


### 3. Security Groups
module "security_groups" {
  source           = "../../modules/security_groups"
  vpc_id           = module.network.vpc_id
  vpc_cidr         = var.vpc_cidr
  trusted_ip_cidr  = var.trusted_ip_cidr
  tags             = var.tags
}

### 4. VPC Endpoints
module "vpc_endpoints" {
  source              = "../../modules/vpc_endpoints"
  region              = var.region
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
  ssm_endpoint_sg_ids = [module.security_groups.vpc_endpoint_sg_id]
  tags                = var.tags
}

### 5. SSM Transfer Bucket
module "ssm_transfer_bucket" {
  source      = "../../modules/ssm_transfer_bucket"
  bucket_name = "ssm-transfer-${var.environment}-99009900"
  region      = var.region
  tags        = var.tags
}

### 6. Compute
module "compute" {
  source = "../../modules/compute"

  ami_id               = var.ami_id
  instance_type        = var.instance_type

  # QA: single AZ
  bastion_subnet_id    = module.network.public_subnet_ids[0]
  frontend_subnet_id   = module.network.private_subnet_ids[0]
  backend_subnet_id    = module.network.private_subnet_ids[1]

  bastion_instance_profile_name  = module.iam.bastion_instance_profile_name
  frontend_instance_profile_name = module.iam.frontend_instance_profile_name
  backend_instance_profile_name  = module.iam.backend_instance_profile_name


  bastion_sg_id  = module.security_groups.bastion_sg_id
  frontend_sg_id = module.security_groups.frontend_sg_id
  backend_sg_id  = module.security_groups.backend_sg_id

  bastion_user_data  = var.bastion_user_data
  frontend_user_data = var.frontend_user_data
  backend_user_data  = var.backend_user_data

  tags = merge(var.tags, {
    Environment = "qa"
    AZStrategy  = "single-az"
    CostCenter  = "lab"
  })
}


### 7. RDS Database
module "database" {
  source                = "../../modules/database"
  db_name               = var.db_name
  db_user               = var.db_user
  db_password           = var.db_password
  instance_class        = var.db_instance_class
  allocated_storage     = var.allocated_storage
  db_subnet_group_name  = var.db_subnet_group_name
  private_subnet_ids    = [module.network.private_subnet_ids[2], module.network.private_subnet_ids[1]]
  db_sg_id              = module.security_groups.db_sg_id
  vpc_id                = module.network.vpc_id
  skip_final_snapshot   = true
  tags                  = var.tags
}

### 8. Application Load Balancer
module "loadbalancer" {
  source            = "../../modules/loadbalancer"
  name              = "movie-alb"
  public_subnet_ids = module.network.public_subnet_ids
  vpc_id            = module.network.vpc_id
  alb_sg_id         = module.security_groups.alb_sg_id
  tags              = var.tags
  frontend_instance_id = module.compute.frontend_instance_id
  backend_instance_id  = module.compute.backend_instance_id
}
