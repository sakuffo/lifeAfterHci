module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"
  # insert the 7 required variables here

  cluster_name = "vmw-eks-cluster"
  cluster_version = "1.20"

  subnets = module.vmw-vpc.private_subnets
  vpc_id = module.vmw-vpc.vpc_id

  worker_groups = [
    {
      name = "vmw-runner-group-1"
      instance_type = "t2.small"
      desired_capacity = 2
    },
    {
      name = "vmw-runner-group-2"
      instance_type = "t2.small"
      desired_capacity = 1
    }
  ]

  tags = {
    environment = "dev"
    application = "vmw"
  }
}
