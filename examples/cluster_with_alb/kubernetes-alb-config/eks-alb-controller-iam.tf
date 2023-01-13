# ALB Policy JSON
resource "aws_iam_policy" "alb_controller_policy" {
  name   = "${local.tags["github_repo"]}-eks-ALBControllerAccessPolicy"
  path   = "/"
  policy = file("${path.module}/policies/aws_loadbalancer_controller_policy.json")
}

#####################################
# IRSA IAM policy for ALB ingress controller
#####################################

data "aws_iam_policy_document" "irsa_alb_controller_trust_policy_doc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        data.aws_iam_openid_connect_provider.alb_example.arn
      ]
    }
    condition {
      test = "StringEquals"
      # this needs to be obtained automatically
      variable = "${data.aws_iam_openid_connect_provider.alb_example.url}:sub"
      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
    condition {
      test = "StringEquals"
      # this needs to be obtained automatically
      variable = "${data.aws_iam_openid_connect_provider.alb_example.url}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "alb_controller_role" {
  name               = "${local.tags["github_repo"]}-EKS-ALB-Controller-ServiceAccount-Role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.irsa_alb_controller_trust_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "alb_policy_attachment" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}
