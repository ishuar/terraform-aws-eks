resource "helm_release" "this" {
  name                       = var.name
  repository                 = var.repository
  chart                      = var.chart
  version                    = var.chart_version
  timeout                    = var.timeout
  values                     = var.values
  create_namespace           = var.create_namespace
  namespace                  = var.namespace
  lint                       = var.lint
  description                = var.description
  repository_key_file        = var.repository_key_file
  repository_cert_file       = var.repository_cert_file
  repository_username        = var.repository_username
  repository_password        = var.repository_password
  verify                     = var.verify
  keyring                    = var.keyring
  disable_webhooks           = var.disable_webhooks
  reuse_values               = var.reuse_values
  reset_values               = var.reset_values
  force_update               = var.force_update
  recreate_pods              = var.recreate_pods
  cleanup_on_fail            = var.cleanup_on_fail
  max_history                = var.max_history
  atomic                     = var.atomic
  skip_crds                  = var.skip_crds
  render_subchart_notes      = var.render_subchart_notes
  disable_openapi_validation = var.disable_openapi_validation
  wait                       = var.wait
  wait_for_jobs              = var.wait_for_jobs
  dependency_update          = var.dependency_update
  replace                    = var.replace


  dynamic "postrender" {
    for_each = var.enable_postrender ? ["postrender_command"] : []
    content {
      binary_path = var.postrender_binary_path
      args        = var.postrender_args
    }
  }

  dynamic "set" {
    for_each = try(var.set, {})

    content {
      name  = set.key
      value = set.value
      type  = "auto"
    }
  }

  dynamic "set_sensitive" {
    for_each = try(var.set_sensitive, {})

    content {
      name  = set_sensitive.key
      value = set_sensitive.value
      type  = "auto"
    }
  }
  depends_on = [module.irsa]
}

module "irsa" {
  source = "../irsa"

  # Required if var.enable_irsa is set to true
  oidc_issuer_url      = var.oidc_issuer_url
  service_account_name = var.service_account_name

  # global controller, only enables this module resources if set to true. default value is false.
  enable_irsa = var.enable_irsa

  # optional
  irsa_role_name                      = var.irsa_role_name
  role_path                           = var.role_path
  force_detach_policies               = var.force_detach_policies
  permissions_boundary                = var.permissions_boundary
  role_policy_arns                    = var.role_policy_arns
  create_service_account              = var.create_service_account
  use_wildcard_service_account_policy = var.use_wildcard_service_account_policy
  aws_account_id                      = var.aws_account_id
  use_wildcard_namespace_policy       = var.use_wildcard_namespace_policy # USE THIS WITH CAUTION !!
  service_account_annotations         = var.service_account_annotations
  automount_service_account_token     = var.automount_service_account_token
  namespace                           = var.namespace
  create_kubernetes_namespace         = var.create_namespace ? false : var.create_kubernetes_namespace
  namespace_labels                    = var.namespace_labels
  namespace_annotations               = var.namespace_annotations
}
