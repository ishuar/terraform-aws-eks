locals {

  aws_region = "eu-central-1"

  tags = {
    provisioner = "terraform"
    module      = "aws-eks"
    github_repo = "terraform-eks"
    example     = "eks-alb"
  }
  cert_arn = "arn:aws:acm:eu-central-1:823459603931:certificate/1d194787-0980-4a2a-8e00-2b0c92b4af0f"
}