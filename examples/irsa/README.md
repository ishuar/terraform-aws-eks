# IAM Roles for Service Account

Configuration in this directory creates an AWS EKS cluster with the underlying network infrastructure. On top of that its creating a example service account which has a role assigned to it with example policy to access AWS.

> The policy arn used in example can be replaced with any sensible policy which can be utilised for some function.
>> Treat this Policy as an example only.

Refer to [IAM Roles For Service Account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) for more details.

### Resources created with this configuration

- Network Infrastrucutre and policies for Cluster Autoscaler with [dependencies.tf](dependencies.tf)
- EKS Cluster with [eks.tf](eks.tf)
- Service account and IRSA with [main.tf](main.tf)

In the `main.tf` there are two examples `complete_irsa` and `minimal_irsa` which shows maximum(all) and minimum (required) attributes with the module.

## Applying the Configuration

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

## Destroying Resources

To destroy the resources created by this Terraform configuration, run the following command.

```bash
terraform destroy -auto-approve # ignore "-auto-approve" if you don't want to autoapprove.
```