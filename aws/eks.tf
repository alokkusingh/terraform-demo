module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  #  subnets         = module.vpc.private_subnets
  version = "20.8.5"
#  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
#  control_plane_subnet_ids = ???

  eks_managed_node_groups = {
    worker-group-1 = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    eks-sec = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-demo-cluster-20240609093518521900000004"

      policy_associations = {
        demo = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

  #worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  #map_roles                            = var.map_roles
  #map_users                            = var.map_users
}

data aws_caller_identity current {
}

data "aws_eks_cluster" "cluster" {
#  name = module.eks.cluster_id
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
   name = module.eks.cluster_name
}


