locals {

  aws_region = "eu-central-1"

  tags = {
    provisioner = "terraform"
    module      = "aws-eks"
    github_repo = "terraform-eks"
    example     = "eks-alb"
  }
}