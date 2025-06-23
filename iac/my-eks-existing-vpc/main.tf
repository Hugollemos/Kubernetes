# Data sources para recursos existentes
data "aws_vpc" "existing" {
  id = var.vpc_id
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  
  filter {
    name   = "subnet-id"
    values = var.private_subnet_ids
  }
}

data "aws_subnet" "private" {
  for_each = toset(var.private_subnet_ids)
  id       = each.value
}

# Módulo EKS Control Plane
module "master" {
  source = "./modules/master"

  cluster_name    = var.cluster_name
  aws_region      = var.aws_region
  k8s_version     = var.k8s_version
  
  cluster_vpc     = data.aws_vpc.existing.id
  private_subnets = var.private_subnet_ids
  
  tags = merge(var.tags, {
    Environment = "production"
    Project     = "eks-existing-vpc"
  })
}

# Módulo Worker Nodes
module "nodes" {
  source = "./modules/nodes"

  cluster_name        = var.cluster_name
  aws_region          = var.aws_region
  k8s_version         = var.k8s_version
  node_group_name     = var.node_group_name

  cluster_vpc         = data.aws_vpc.existing.id
  private_subnets     = var.private_subnet_ids

  eks_cluster         = module.master.eks_cluster
  eks_cluster_sg      = module.master.security_group

  nodes_instances_sizes = var.nodes_instances_sizes
  auto_scale_options    = var.auto_scale_options
  
  tags = merge(var.tags, {
    Environment = "production"
    Project     = "eks-existing-vpc"
  })

  depends_on = [module.master]
}
