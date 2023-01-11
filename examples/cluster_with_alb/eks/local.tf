locals {

  encrypt_jump_host = true
  aws_region        = "eu-central-1"
  endpoint_prefix   = "com.amazonaws"

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
    provisioner = "terraform"
    module      = "aws-eks"
    github_repo = "terraform-eks"
    example     = "eks-alb"
  }

}
