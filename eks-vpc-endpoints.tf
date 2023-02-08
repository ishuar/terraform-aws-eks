resource "aws_vpc_endpoint" "ec2" {
  count = var.enable_ec2_vpc_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ec2"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.endpoint_security_group_ids
  subnet_ids          = var.subnet_ids
  private_dns_enabled = var.endpoint_private_dns_enabled
  tags = merge(
    {
      Name = "ep-${var.vpc_id}-${data.aws_region.current.name}-ec2"
    },
  var.tags)
}

resource "aws_vpc_endpoint" "elasticloadbalancing" {
  count = var.enable_elasticloadbalancing_vpc_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.elasticloadbalancing"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.endpoint_security_group_ids
  subnet_ids          = var.subnet_ids
  private_dns_enabled = var.endpoint_private_dns_enabled
  tags = merge(
    {
      Name = "ep-${var.vpc_id}-${data.aws_region.current.name}-elasticloadbalancing"
    },
  var.tags)
}
resource "aws_vpc_endpoint" "ecr_api" {
  count = var.enable_ecr_api_vpc_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.endpoint_security_group_ids
  subnet_ids          = var.subnet_ids
  private_dns_enabled = var.endpoint_private_dns_enabled
  tags = merge(
    {
      Name = "ep-${var.vpc_id}-${data.aws_region.current.name}-ecr.api"
    },
  var.tags)
}
resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.enable_ecr_dkr_vpc_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.endpoint_security_group_ids
  subnet_ids          = var.subnet_ids
  private_dns_enabled = var.endpoint_private_dns_enabled
  tags = merge(
    {
      Name = "ep-${var.vpc_id}-${data.aws_region.current.name}-ecr.dkr"
    },
  var.tags)
}
resource "aws_vpc_endpoint" "sts" {
  count = var.enable_sts_vpc_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.sts"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.endpoint_security_group_ids
  subnet_ids          = var.subnet_ids
  private_dns_enabled = var.endpoint_private_dns_enabled
  tags = merge(
    {
      Name = "ep-${var.vpc_id}-${data.aws_region.current.name}-sts"
    },
  var.tags)
}

resource "aws_vpc_endpoint" "logs" {
  count = var.enable_logs_vpc_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.endpoint_security_group_ids
  subnet_ids          = var.subnet_ids
  private_dns_enabled = var.endpoint_private_dns_enabled
  tags = merge(
    {
      Name = "ep-${var.vpc_id}-${data.aws_region.current.name}-logs"
    },
  var.tags)
}

## For S3 gateway endpoint, only route table IDs are required. 

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_vpc_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = var.endpoint_private_dns_enabled
  route_table_ids     = var.endpoint_route_table_ids
  tags = merge(
    {
      Name = "ep-${var.vpc_id}-${data.aws_region.current.name}-s3-gateway"
    },
  var.tags)
}
