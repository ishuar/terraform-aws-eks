locals {

  encrypt_jump_host = true
  aws_region        = "eu-central-1"
  endpoint_prefix   = "com.amazonaws"

  private_subnets = {
    "10.0.1.0/24" = {
      az = "eu-central-1a"
    }
    "10.0.3.0/24" = {
      az = "eu-central-1b"
    }
  }
  public_subnets = {
    "10.0.2.0/24" = {
      az = "eu-central-1a"
    }
    "10.0.4.0/24" = {
      az = "eu-central-1b"
    }
  }

  tags = {
    provisioner = "terraform"
    module      = "aws-eks"
    github_repo = "terraform-eks"
  }

}
