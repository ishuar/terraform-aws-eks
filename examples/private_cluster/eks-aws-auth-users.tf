/*
!! Important !!

* With Private Cluster it is not possible to run kubernetes commands to modify the aws-auth configmap
* with public github/any runners executing terraform code as they can not access Kubernetes API.
* In this case aws-config config map has to be manually adjusted with the user which created the
* EKS cluster.

* If you are using private runner which has network access to EKS cluster, its possible to update
* the aws-auth configmap using correct kubernetes provider configuration via terraform to update
* Kubernetes RBAC with AWS IAM.
*/


# resource "kubernetes_config_map" "aws_auth" {

#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = module.eks_private.node_group_role_arn
#         username = "system:node:{{EC2PrivateDNSName}}"
#         groups = concat(
#           [
#             "system:bootstrappers",
#             "system:nodes",
#           ]
#         )
#       },
#       {
#         rolearn = 
#         username = "private-jump-host"
#         groups = concat(
#           [
#             "system:masters"
#             role_arn = aws_iam_role.jumphost_eks_api_access_role.arn
#           ]
#         )
#       }
#     ]
#     )
#     # mapUsers    = yamlencode(concat(var.operator_users, var.dev_users))
#     # mapAccounts = yamlencode(var.map_accounts)
#   }

#   depends_on = [modue.eks_private]

# }
