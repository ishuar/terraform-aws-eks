terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket         = "ishuar-terraform"
    key            = "eks-with-alb"
    region         = "eu-central-1"
    dynamodb_table = "ishuar"
  }
}

provider "aws" {
  region = local.aws_region
}
