
data "aws_eks_cluster" "vmw-cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "vmw-cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host             = data.aws_eks_cluster.vmw-cluster.endpoint
  token            = data.aws_eks_cluster_auth.vmw-cluster.token
  #no python lib to decode the token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.vmw-cluster.certificate_authority.0.data)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"
  # insert the 7 required variables here

  cluster_name    = "vmw-eks-cluster"
  cluster_version = "1.20"

  subnets = module.vmw-vpc.private_subnets
  vpc_id  = module.vmw-vpc.vpc_id

  worker_groups = [
    {
      name             = "vmw-runner-group-1"
      instance_type    = "t2.small"
      asg_desired_capacity = 2
      min_size         = 2
    },
    {
      name             = "vmw-runner-group-2"
      instance_type    = "t2.small"
      asg_desired_capacity = 1
    }
  ]

  tags = {
    environment = "dev"
    application = "vmw"
  }
}
