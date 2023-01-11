# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster
## EKS cluster has to deployed first , use same name used in the eks deployment.
data "aws_eks_cluster" "alb_example" {
  name = "${local.tags["github_repo"]}-repo-public-alb-cluster"
}

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider
data "aws_iam_openid_connect_provider" "alb_example" {
  url = data.aws_eks_cluster.alb_example.identity[0].oidc[0].issuer
}

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth
data "aws_eks_cluster_auth" "alb_example" {
  name = "${local.tags["github_repo"]}-repo-public-alb-cluster"
}

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "alb_example" {

  filter {
    name   = "tag:example"
    values = ["eks-alb"]
  }
  filter {
    name   = "tag:github_repo"
    values = ["terraform-eks"]
  }
}
data "aws_subnet" "alb_example_public_1" {
  ## name filter is enough but just to avoid any conflicts in account.
  filter {
    name   = "tag:Name"
    values = ["snet-eks-alb-example-public-${local.aws_region}-01"]
  }
  filter {
    name   = "tag:example"
    values = ["eks-alb"]
  }
  filter {
    name   = "tag:github_repo"
    values = ["terraform-eks"]
  }
}

data "aws_subnet" "alb_example_public_2" {
  ## name filter is enough but just to avoid any conflicts in account.
  filter {
    name   = "tag:Name"
    values = ["snet-eks-alb-example-public-${local.aws_region}-02"]
  }
  filter {
    name   = "tag:example"
    values = ["eks-alb"]
  }
  filter {
    name   = "tag:github_repo"
    values = ["terraform-eks"]
  }
}

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate

data "aws_acm_certificate" "alb_example" {
  domain      = "worldofcontainers.tk"
  key_types   = ["EC_prime256v1"] ## assume it as an required attribute for all time functionality.
  types       = ["AMAZON_ISSUED"]
  statuses    = ["ISSUED"]
  most_recent = true
}

# ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group
## Additional Security group for EKS Node group and API
data "aws_security_group" "additional_eks_security_group" {
  filter {
    name   = "tag:Name"
    values = ["addditional-eks-cluster-access"]
  }
  filter {
    name   = "tag:example"
    values = ["eks-alb"]
  }
  filter {
    name   = "tag:github_repo"
    values = ["terraform-eks"]
  }
}
