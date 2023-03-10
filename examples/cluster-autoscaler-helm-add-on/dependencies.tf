resource "aws_vpc" "eks" {
  cidr_block           = "10.0.0.0/16"
  tags                 = merge(local.tags, { Name = "vpc-eks-${local.aws_region}-01" })
  enable_dns_hostnames = true
}

resource "aws_subnet" "private_subnets" {
  for_each = local.private_subnets

  cidr_block        = each.key
  vpc_id            = aws_vpc.eks.id
  availability_zone = each.value.az
  tags              = merge(local.tags, { Name = "${each.value.name}" })

}
resource "aws_subnet" "public_subnets" {
  for_each = local.public_subnets

  cidr_block              = each.key
  vpc_id                  = aws_vpc.eks.id
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags                    = merge(local.tags, { Name = "${each.value.name}" })
}

## Security Group for Endpoints.
resource "aws_security_group" "eks_endpoints" {
  name        = "allow-endpoints-eks"
  description = "Security group for allowing Endpoints within VPC"
  vpc_id      = aws_vpc.eks.id

  tags = merge(
    {
      Name = "allow-endpoints-eks"
    }
  , local.tags)
}

resource "aws_security_group_rule" "eks_endpoints" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "To allow https VPC internal traffic"
  cidr_blocks       = [aws_vpc.eks.cidr_block]
  security_group_id = aws_security_group.eks_endpoints.id
}

## Additional Security Group for EKS API and NodeGroup Access.

resource "aws_security_group" "eks_additional" {
  name        = "addditional-eks-cluster-access"
  description = "Additional Security group for allowing access to EKS API and Node group communication."
  vpc_id      = aws_vpc.eks.id

  tags = merge(
    {
      Name = "addditional-eks-cluster-access"
    }
  , local.tags)
}

resource "aws_security_group_rule" "eks_additional" {
  for_each          = local.private_subnets
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "To allow https access from only private subnets ${aws_subnet.private_subnets[each.key].cidr_block}"
  cidr_blocks       = [aws_subnet.private_subnets[each.key].cidr_block]
  security_group_id = aws_security_group.eks_additional.id
}

## Public Routing
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks.id

  tags = merge(
    { "Name" = "rt-eks-public" },
    local.tags,
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.eks.id

  tags = merge(
    { "Name" = "vpc-eks-${local.aws_region}-01" },
    local.tags,
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public.id
}

## Private Routing

resource "aws_eip" "eks_nat_eip" {
  vpc = true
  tags = merge(
    {
      Name = "pip-eks-natgw"
    },
  local.tags)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks.id

  tags = merge(
    {
      Name = "rt-eks-private"
    },
  local.tags, )
}

resource "aws_nat_gateway" "this" {

  allocation_id = aws_eip.eks_nat_eip.allocation_id
  subnet_id     = aws_subnet.public_subnets["10.0.2.0/24"].id

  tags = merge(
    {
      Name = "vpc-eks-${local.aws_region}-01"
    },
  local.tags)

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id

}
resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.private.id
}

## Policies

resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name        = "AmazonEKSClusterAutoscalerPolicy-01"
  description = "cluster autoscaler policy for AWS autoscaler service account and role"
  policy      = data.aws_iam_policy_document.cluster_autoscaler_policy.json
}

# https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md#full-cluster-autoscaler-features-policy-recommended
#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "cluster_autoscaler_policy" {
  version = "2012-10-17"

  statement {
    sid    = "AllowAutoscaling1"
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowAutoscaling2"
    effect = "Allow"
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeImages",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${local.cluster_name}"
      values = [
        "owned"
      ]
    }
    resources = ["*"]
  }
}
