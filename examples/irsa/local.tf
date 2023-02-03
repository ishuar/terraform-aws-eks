locals {

  aws_region = "eu-central-1"

  private_subnets = {
    "10.0.1.0/24" = {
      az   = "eu-central-1a"
      name = "snet-eks-alb-example-private-${local.aws_region}-01"
    }
    "10.0.3.0/24" = {
      az   = "eu-central-1b"
      name = "snet-eks-alb-example-private-${local.aws_region}-02"
    }
  }
  public_subnets = {
    "10.0.2.0/24" = {
      az   = "eu-central-1a"
      name = "snet-eks-alb-example-public-${local.aws_region}-01"
    }
    "10.0.4.0/24" = {
      az   = "eu-central-1b"
      name = "snet-eks-alb-example-public-${local.aws_region}-02"
    }
  }

  tags = {
    github_repo = "terraform-aws-eks"
    example     = "irsa"
  }

  service_account_names = {
    complete_service_account_name = "irsa-service-account-complete"
    minimal_service_account_name  = "irsa-service-account-minimal"
  }
  cluster_name = module.irsa_eks.eks_cluster_name

}
