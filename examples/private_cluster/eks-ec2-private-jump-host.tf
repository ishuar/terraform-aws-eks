
data "aws_caller_identity" "current" {}

## endpoints required for the provate ec2 instance accessed via SSM.
resource "aws_vpc_endpoint" "ec2messages" {

  vpc_id             = aws_vpc.eks.id
  service_name       = "${local.endpoint_prefix}.${local.aws_region}.ec2messages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_subnets["10.0.1.0/24"].id, aws_subnet.private_subnets["10.0.3.0/24"].id]
  security_group_ids = [aws_security_group.eks_endpoints.id]
  tags = merge(
    {
      Name = "ep-${aws_vpc.eks.id}-${local.endpoint_prefix}.${local.aws_region}.ec2message"
  }, local.tags)
}

resource "aws_vpc_endpoint" "ssm" {

  vpc_id             = aws_vpc.eks.id
  service_name       = "${local.endpoint_prefix}.${local.aws_region}.ssm"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_subnets["10.0.1.0/24"].id, aws_subnet.private_subnets["10.0.3.0/24"].id]
  security_group_ids = [aws_security_group.eks_endpoints.id]
  tags = merge(
    {
      Name = "ep-${aws_vpc.eks.id}-${local.endpoint_prefix}.${local.aws_region}.ec2message"
  }, local.tags)
}

resource "aws_vpc_endpoint" "ssmmessages" {

  vpc_id             = aws_vpc.eks.id
  service_name       = "${local.endpoint_prefix}.${local.aws_region}.ssmmessages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_subnets["10.0.1.0/24"].id, aws_subnet.private_subnets["10.0.3.0/24"].id]
  security_group_ids = [aws_security_group.eks_endpoints.id]
  tags = merge(
    {
      Name = "ep-${aws_vpc.eks.id}-${local.endpoint_prefix}.${local.aws_region}.ec2message"
  }, local.tags)
}

## Policies and role needed for the jump host to access EKS cluster API.
data "aws_iam_policy_document" "jumphost_assume_role_policy" {

  statement {
    sid     = "privateJumpHostAssumeStatement"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "jumphost_eks_api_access_policy" {

  statement {
    sid       = "privateJumpHostEksApiStatememt"
    actions   = ["eks:DescribeCluster"]
    resources = [module.eks_private.eks_cluster_arn]
  }
}

## In order to get the arn [create the policy] for the policy of the api_access_policy document.
resource "aws_iam_policy" "ec2_jump_host_policy" {

  name   = "ec2-api-access-to-eks-001"
  path   = "/"
  policy = data.aws_iam_policy_document.jumphost_eks_api_access_policy.json
}

## Role for Jump Host Instance Profile.
resource "aws_iam_role" "jumphost_eks_api_access_role" {
  name               = "ec2-eks-api-access-role-001"
  description        = "Role to access EKS cluster API from EC2 service"
  assume_role_policy = data.aws_iam_policy_document.jumphost_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_api_access" {

  policy_arn = aws_iam_policy.ec2_jump_host_policy.arn
  role       = aws_iam_role.jumphost_eks_api_access_role.name
}


resource "aws_iam_role_policy_attachment" "jumphost_AmazonSSMManagedInstanceCore" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.jumphost_eks_api_access_role.name
}

## If SSM Manager is using encryption Key for encrypting the Sessions.
data "aws_kms_key" "ssm_session_key" {

  key_id = "alias/kms-ssm-session-manager-eu-central-1-dev" ## Use the alias for the key which is being used for SSM session manager encryption.
}

data "aws_iam_policy_document" "jumphost_ssm_session_access_policy" {

  statement {
    sid = "privateJumpHostSsmSessionKeyAccess"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey",
    ]
    resources = [data.aws_kms_key.ssm_session_key.arn]
  }
}

resource "aws_iam_policy" "jumphost_ssm_session_access_policy" {

  name   = "ec2-ssm-session-kms-key-001"
  path   = "/"
  policy = data.aws_iam_policy_document.jumphost_ssm_session_access_policy.json
}

resource "aws_iam_role_policy_attachment" "jumphost_ssm_session_access_policy" {

  policy_arn = aws_iam_policy.jumphost_ssm_session_access_policy.arn
  role       = aws_iam_role.jumphost_eks_api_access_role.name
}

## EC2 Security Group for Egress Traffic [ Help SSM to Access it ]
resource "aws_security_group" "jump_host_access" {

  name        = "eks-jump-host-${local.aws_region}-security-group"
  description = "Security group for EKS jump host access"
  vpc_id      = aws_vpc.eks.id

  tags = merge(
    local.tags,
    {
      "Name" = "eks-jump-host-${local.aws_region}-security-group"
    },
  )
}

resource "aws_security_group_rule" "jump_host_access_egress" {

  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  type              = "egress"
  description       = "Security Rule to allow all egress traffic from jump Host on port 443"
  security_group_id = aws_security_group.jump_host_access.id
}

## EC2 Kms Key (If need to encrypt the EC2 EBS volume)
resource "aws_kms_key" "eks_jump_host" {
  count = local.encrypt_jump_host ? 1 : 0

  description              = "KMS key for the EC2 jump private host EBS encryption."
  deletion_window_in_days  = 30
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true # key rotation should happen every year
  is_enabled               = true
  tags                     = local.tags
  policy                   = data.aws_iam_policy_document.eks_jump_host[0].json
}

### Adding alias for the key
resource "aws_kms_alias" "eks_jump_host" {
  count = local.encrypt_jump_host ? 1 : 0

  name          = "alias/kms-ec2-encryption"
  target_key_id = aws_kms_key.eks_jump_host[0].key_id
}
data "aws_iam_policy_document" "eks_jump_host" {
  count = local.encrypt_jump_host ? 1 : 0


  version = "2012-10-17"

  ## Default KMS key policy
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "kmsPermissionsInstanceProfile"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.jumphost_eks_api_access_role.arn]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }
}

# ## EC2 instance specific configuration.
data "aws_ami" "amazonLinux2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_iam_instance_profile" "eks_jump_host" {

  name = "eks-jump-host-profile-${local.aws_region}-dev"
  role = aws_iam_role.jumphost_eks_api_access_role.name
  tags = local.tags
}
## Private KEY in AWS secret manager for Access when SSM is having issues.(ignore if not required)
resource "aws_key_pair" "eks_jump_host" {
  key_name   = "eks-private-jump-host-${local.aws_region}-dev-key"
  public_key = file("${path.module}/jump-host-key.pub")
  tags       = local.tags
}

resource "aws_instance" "eks_jump_host" {

  ami                    = data.aws_ami.amazonLinux2.id
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.private_subnets["10.0.1.0/24"].id
  iam_instance_profile   = aws_iam_instance_profile.eks_jump_host.name
  vpc_security_group_ids = [aws_security_group.jump_host_access.id]
  key_name               = aws_key_pair.eks_jump_host.key_name

  user_data = templatefile("${path.module}/cloud-init-userdata.yaml",
    {
      CLUSTER = module.eks_private.eks_cluster_name,
      REGION  = local.aws_region
    }
  )

  root_block_device {
    kms_key_id = aws_kms_key.eks_jump_host[0].arn
    encrypted  = local.encrypt_jump_host
  }

  tags = merge(local.tags,
    {
      Name = "eks-private-jump-host-${local.aws_region}-${local.tags["github_repo"]}"
    }
  )

  lifecycle {
    ignore_changes = [
      ami,
    ]
  }

  depends_on = [
    aws_vpc_endpoint.ec2messages,
    aws_vpc_endpoint.ssm,
    aws_vpc_endpoint.ssmmessages,
  ]
}
