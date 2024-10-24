module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.2"

  cluster_name    = "web3-eks"
  cluster_version = "1.30"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  enable_cluster_creator_admin_permissions = true

  authentication_mode = "API"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 100
  }

  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 4

      labels = {
        role = "general"
      }

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
    }

  }

  tags = {
    Env = var.env
    App = var.app
  }
}
