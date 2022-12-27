################################################################################
# Launch template
################################################################################

locals {
  launch_template_name = coalesce(var.launch_template_name, "${var.name}-node-group")
  security_group_ids   = compact(concat([aws_eks_cluster.this[0].vpc_config[0].cluster_security_group_id], var.cluster_additional_security_group_ids))
}

resource "aws_launch_template" "this" {
  count = var.create_node_group && var.create_launch_template && var.use_launch_template ? 1 : 0

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings

    content {
      device_name = try(block_device_mappings.value.device_name, null)

      dynamic "ebs" {
        for_each = try([block_device_mappings.value.ebs], [])

        content {
          delete_on_termination = try(ebs.value.delete_on_termination, null)
          encrypted             = try(ebs.value.encrypted, null)
          iops                  = try(ebs.value.iops, null)
          kms_key_id            = ebs.value.encrypted ? (local.create_global_eks_kms_key ? aws_kms_key.this[0].arn : ebs.value.kms_key_id) : null
          snapshot_id           = try(ebs.value.snapshot_id, null)
          throughput            = try(ebs.value.throughput, null)
          volume_size           = try(ebs.value.volume_size, null)
          volume_type           = try(ebs.value.volume_type, null)
        }
      }

      no_device    = try(block_device_mappings.value.no_device, null)
      virtual_name = try(block_device_mappings.value.virtual_name, null)
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = length(var.capacity_reservation_specification) > 0 ? [var.capacity_reservation_specification] : []

    content {
      capacity_reservation_preference = try(capacity_reservation_specification.value.capacity_reservation_preference, null)

      dynamic "capacity_reservation_target" {
        for_each = try([capacity_reservation_specification.value.capacity_reservation_target], [])

        content {
          capacity_reservation_id                 = try(capacity_reservation_target.value.capacity_reservation_id, null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target.value.capacity_reservation_resource_group_arn, null)
        }
      }
    }
  }

  dynamic "cpu_options" {
    for_each = length(var.cpu_options) > 0 ? [var.cpu_options] : []

    content {
      core_count       = try(cpu_options.value.core_count, null)
      threads_per_core = try(cpu_options.value.threads_per_core, null)
    }
  }

  dynamic "credit_specification" {
    for_each = length(var.credit_specification) > 0 ? [var.credit_specification] : []

    content {
      cpu_credits = try(credit_specification.value.cpu_credits, null)
    }
  }

  default_version         = var.launch_template_default_version
  description             = "Launch Template for the node groups associated with the EKS cluster: ${var.name}"
  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized

  dynamic "elastic_gpu_specifications" {
    for_each = var.elastic_gpu_specifications

    content {
      type = elastic_gpu_specifications.value.type
    }
  }

  dynamic "elastic_inference_accelerator" {
    for_each = length(var.elastic_inference_accelerator) > 0 ? [var.elastic_inference_accelerator] : []

    content {
      type = elastic_inference_accelerator.value.type
    }
  }

  dynamic "enclave_options" {
    for_each = length(var.enclave_options) > 0 ? [var.enclave_options] : []

    content {
      enabled = enclave_options.value.enabled
    }
  }

  # Set on EKS managed node group, will fail if set here
  # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-basics
  # dynamic "hibernation_options" {
  #   for_each = length(var.hibernation_options) > 0 ? [var.hibernation_options] : []

  #   content {
  #     configured = hibernation_options.value.configured
  #   }
  # }

  # Set on EKS managed node group, will fail if set here
  # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-basics
  # dynamic "iam_instance_profile" {
  #   for_each = [var.iam_instance_profile]
  #   content {
  #     name = lookup(var.iam_instance_profile, "name", null)
  #     arn  = lookup(var.iam_instance_profile, "arn", null)
  #   }
  # }

  image_id = var.ami_id
  # Set on EKS managed node group, will fail if set here
  # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-basics
  # instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  dynamic "instance_market_options" {
    for_each = length(var.instance_market_options) > 0 ? [var.instance_market_options] : []

    content {
      market_type = try(instance_market_options.value.market_type, null)

      dynamic "spot_options" {
        for_each = try([instance_market_options.value.spot_options], [])

        content {
          block_duration_minutes         = try(spot_options.value.block_duration_minutes, null)
          instance_interruption_behavior = try(spot_options.value.instance_interruption_behavior, null)
          max_price                      = try(spot_options.value.max_price, null)
          spot_instance_type             = try(spot_options.value.spot_instance_type, null)
          valid_until                    = try(spot_options.value.valid_until, null)
        }
      }
    }
  }

  # # Set on node group instead
  # instance_type = var.launch_template_instance_type
  kernel_id = var.kernel_id
  key_name  = var.key_name

  dynamic "license_specification" {
    for_each = length(var.license_specifications) > 0 ? var.license_specifications : {}

    content {
      license_configuration_arn = license_specifications.value.license_configuration_arn
    }
  }

  dynamic "maintenance_options" {
    for_each = length(var.maintenance_options) > 0 ? [var.maintenance_options] : []

    content {
      auto_recovery = try(maintenance_options.value.auto_recovery, null)
    }
  }

  dynamic "metadata_options" {
    for_each = length(var.metadata_options) > 0 ? [var.metadata_options] : []

    content {
      http_endpoint               = try(metadata_options.value.http_endpoint, null)
      http_protocol_ipv6          = try(metadata_options.value.http_protocol_ipv6, null)
      http_put_response_hop_limit = try(metadata_options.value.http_put_response_hop_limit, null)
      http_tokens                 = try(metadata_options.value.http_tokens, null)
      instance_metadata_tags      = try(metadata_options.value.instance_metadata_tags, null)
    }
  }

  dynamic "monitoring" {
    for_each = var.enable_monitoring ? [1] : []

    content {
      enabled = var.enable_monitoring
    }
  }

  name = local.launch_template_name

  dynamic "network_interfaces" {
    for_each = var.network_interfaces
    content {
      associate_carrier_ip_address = try(network_interfaces.value.associate_carrier_ip_address, null)
      associate_public_ip_address  = try(network_interfaces.value.associate_public_ip_address, null)
      delete_on_termination        = try(network_interfaces.value.delete_on_termination, null)
      description                  = try(network_interfaces.value.description, null)
      device_index                 = try(network_interfaces.value.device_index, null)
      interface_type               = try(network_interfaces.value.interface_type, null)
      ipv4_address_count           = try(network_interfaces.value.ipv4_address_count, null)
      ipv4_addresses               = try(network_interfaces.value.ipv4_addresses, [])
      ipv4_prefix_count            = try(network_interfaces.value.ipv4_prefix_count, null)
      ipv4_prefixes                = try(network_interfaces.value.ipv4_prefixes, null)
      ipv6_address_count           = try(network_interfaces.value.ipv6_address_count, null)
      ipv6_addresses               = try(network_interfaces.value.ipv6_addresses, [])
      ipv6_prefix_count            = try(network_interfaces.value.ipv6_prefix_count, null)
      ipv6_prefixes                = try(network_interfaces.value.ipv6_prefixes, [])
      network_card_index           = try(network_interfaces.value.network_card_index, null)
      network_interface_id         = try(network_interfaces.value.network_interface_id, null)
      private_ip_address           = try(network_interfaces.value.private_ip_address, null)
      # Ref: https://github.com/hashicorp/terraform-provider-aws/issues/4570
      security_groups = compact(concat(try(network_interfaces.value.security_groups, []), local.security_group_ids))
      # Set on EKS managed node group, will fail if set here
      # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-basics
      # subnet_id       = try(network_interfaces.value.subnet_id, null)
    }
  }

  dynamic "placement" {
    for_each = length(var.placement) > 0 ? [var.placement] : []

    content {
      affinity                = try(placement.value.affinity, null)
      availability_zone       = try(placement.value.availability_zone, null)
      group_name              = try(placement.value.group_name, null)
      host_id                 = try(placement.value.host_id, null)
      host_resource_group_arn = try(placement.value.host_resource_group_arn, null)
      partition_number        = try(placement.value.partition_number, null)
      spread_domain           = try(placement.value.spread_domain, null)
      tenancy                 = try(placement.value.tenancy, null)
    }
  }

  dynamic "private_dns_name_options" {
    for_each = length(var.private_dns_name_options) > 0 ? [var.private_dns_name_options] : []

    content {
      enable_resource_name_dns_aaaa_record = try(private_dns_name_options.value.enable_resource_name_dns_aaaa_record, null)
      enable_resource_name_dns_a_record    = try(private_dns_name_options.value.enable_resource_name_dns_a_record, null)
      hostname_type                        = try(private_dns_name_options.value.hostname_type, null)
    }
  }

  ram_disk_id = var.ram_disk_id

  dynamic "tag_specifications" {
    for_each = toset(["instance", "volume", "elastic-gpu", "network-interface", "spot-instances-request"])

    ## TODO: Configure the tag specifications for node group level
    content {
      resource_type = tag_specifications.key
      tags          = merge(var.tags, { Name = "${var.name}-node-group" }, var.launch_template_tags)
    }
  }

  update_default_version = var.update_launch_template_default_version
  user_data              = var.user_data
  vpc_security_group_ids = length(var.network_interfaces) > 0 ? [] : local.security_group_ids

  tags = var.tags

  # Prevent premature access of policies by pods that
  # require permissions on create/destroy that depend on nodes
  depends_on = [
    aws_iam_role_policy_attachment.node_group,
  ]

  lifecycle {
    create_before_destroy = true
  }
}
