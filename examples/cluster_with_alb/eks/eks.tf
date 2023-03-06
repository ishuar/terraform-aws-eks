module "public_eks_with_alb" {
  source  = "ishuar/eks/aws"
  version = "~> 1.3"

  name                                  = "${local.tags["github_repo"]}-repo-public-alb-cluster"
  cluster_version                       = "1.24"
  create_eks_cluster                    = true
  create_cluster_iam_role               = true
  attach_cluster_encryption_policy      = true
  create_cloudwatch_log_group           = true
  cluster_iam_role_name                 = "${local.tags["github_repo"]}-repo-private-cluster-role"
  subnet_ids                            = [aws_subnet.private_subnets["10.0.1.0/24"].id, aws_subnet.private_subnets["10.0.3.0/24"].id]
  vpc_id                                = aws_vpc.eks.id
  cluster_additional_security_group_ids = [aws_security_group.eks_additional.id]


  ## Create Global KMS key for node and EKS cluster encryption.
  create_encryption_kms_key = true

  # Node groups Config.
  create_node_group          = true
  create_node_group_iam_role = true
  use_launch_template        = true
  node_group_iam_role_name   = "${local.tags["github_repo"]}-repo-private-nodegroup-role"
  ebs_optimized              = true
  enable_monitoring          = false

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
      instance_types = ["t3.medium"] ## ["m5.large"] Pre-requisite for https://www.eksworkshop.com/beginner/115_sg-per-pod/09_prerequisite/
    }
  }

  tags = local.tags

}
