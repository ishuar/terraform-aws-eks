module "irsa_eks" {
  source  = "ishuar/eks/aws"
  version = "~> 1.3"

  name                                  = "${local.tags["github_repo"]}-irsa-example"
  cluster_version                       = "1.24"
  cluster_iam_role_name                 = "${local.tags["github_repo"]}-irsa-example"
  subnet_ids                            = [aws_subnet.private_subnets["10.0.1.0/24"].id, aws_subnet.private_subnets["10.0.3.0/24"].id]
  vpc_id                                = aws_vpc.eks.id
  cluster_additional_security_group_ids = [aws_security_group.eks_additional.id]
  create_encryption_kms_key             = true
  use_launch_template                   = true
  node_group_iam_role_name              = "${local.tags["github_repo"]}-repo-irsa-example-nodegroup-role"

  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        encrypted             = true
        delete_on_termination = true
        volume_size           = 80
        volume_type           = "gp3"
      }
    }
  }

  node_groups = {
    node_group_001 = {
      min_size       = 0
      max_size       = 2
      desired_size   = 1
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]
    }
  }

  tags = local.tags

}
