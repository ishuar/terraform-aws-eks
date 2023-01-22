## Security Group for ALB [ Allow Everyone from internet on HTTPS]
resource "aws_security_group" "internet_alb" {
  name        = "internet-alb-443"
  description = "Allow TLS inbound traffic from everywhere."
  vpc_id      = data.aws_vpc.alb_example.id

  ingress {
    description = "TLS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "allow_http_to_additonal_eks" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "To allow ALB into EKS Additional SG for service ingress requests"
  source_security_group_id = data.aws_security_group.additional_eks_security_group.id
  security_group_id        = aws_security_group.internet_alb.id
}

## Security Group Rule to allow ALB HTTP access to EKS Additional Security group
resource "aws_security_group_rule" "allow_http_from_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "To allow ALB into EKS Additional SG for service ingress requests"
  source_security_group_id = aws_security_group.internet_alb.id
  security_group_id        = data.aws_security_group.additional_eks_security_group.id
}
