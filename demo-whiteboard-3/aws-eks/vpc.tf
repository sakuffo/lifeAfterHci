provider "aws" {
  region = var.region
}

variable "vpc_cider_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}
variable "region" {}

data "aws_availability_zones" "azs" {

}

module "vmw-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name = "vmw-vpc"
  cidr = var.vpc_cider_block
  # best practice 1: is 1 privatre and 1 public subnet in each AZ
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks
  azs             = data.aws_availability_zones.azs.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true


  # eks best practice: adding labels to allow EKS cloud contronller to find the cluster  
  # required
  tags = {
    "kubernetes.io/cluster/vmw-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/vmw-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/vmw-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}