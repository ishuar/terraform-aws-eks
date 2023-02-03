terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

provider "helm" {
  kubernetes {
    host                   = module.helm_add_on_eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.helm_add_on_eks.eks_cluster_certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
      command     = "aws"
    }
  }
}
provider "kubernetes" {
  host                   = module.helm_add_on_eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.helm_add_on_eks.eks_cluster_certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}

