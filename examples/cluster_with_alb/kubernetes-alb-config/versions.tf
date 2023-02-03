terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket         = "ishuar-terraform"
    key            = "eks-with-alb-k8s"
    region         = "eu-central-1"
    dynamodb_table = "ishuar"
  }
}

provider "aws" {
  region = local.aws_region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.alb_example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.alb_example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.alb_example.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.alb_example.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.alb_example.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.alb_example.token
  }
}
