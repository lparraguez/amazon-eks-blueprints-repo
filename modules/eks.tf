data "aws_availability_zones" "available" {}

locals {
  tags = {
    created-by = var.terraform_tag    
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = var.vpc_cluster_name

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
    "created-by"                                  = "${var.terraform_tag}"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
    "created-by"                                  = "${var.terraform_tag}"
  }

  tags = {
    created-by = var.terraform_tag    
  }
}

module "eks_blueprints" {
  source  = "github.com/aws-ia/terraform-aws-eks-blueprints"
  
  # EKS CLUSTER
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id                          = module.vpc.vpc_id
  private_subnet_ids              = module.vpc.private_subnets
  public_subnet_ids               = module.vpc.public_subnets
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # List of map_roles - Additional IAM roles to add to the aws-auth ConfigMap
  map_roles           = var.map_roles

  # List of map_users - Additional IAM users to add to the aws-auth ConfigMap
  map_users           = var.map_users

  # List of map_accounts - Additional AWS accounts to add to the aws-auth ConfigMap
  map_accounts        = var.map_accounts
      
  managed_node_groups = {
    # Managed Node groups with Launch templates using AMI TYPE
    mng_01 = {
      # Node Group configuration
      node_group_name = "managed-ondemand"
    
      # Node Group scaling configuration
      min_size        = 3
      max_size        = 6
      desired_size    = 3

      # Node Group compute configuration
      ami_type        = var.node_ami_type # Amazon Linux 2 (AL2_x86_64)
      release_version = var.ami_release_version ## Enter AMI release version to deploy the latest AMI released by AWS
      capacity_type   = "ON_DEMAND"  # ON_DEMAND or SPOT
      instance_types  = var.node_instance_type # List of instances to get capacity from multiple pools
      
      # Node Group network configuration
      subnet_ids = module.vpc.private_subnets # Define private/public subnets list with comma separated 

    }
  }

  tags = {
    created-by = var.terraform_tag    
  }
  
}