# Changelog

All notable changes to this project will be documented in this file.

## [v1.5.0](https://github.com/ishuar/terraform-aws-eks/compare/v1.4.1...v1.5.0)

### Bug

- Made examples `private_cluster` and `cluster_with_alb` deployable without any changes.

## [v1.4.1](https://github.com/ishuar/terraform-aws-eks/compare/v1.4.0...v1.4.1)

### Bug

- Updated root readme file with last release.

## [v1.4.0](https://github.com/ishuar/terraform-aws-eks/compare/v1.3.0...v1.4.0)

### Features

- Added Submodules
  - irsa
  - helm-add-on
- Added Examples for submodules.
- Added [AWS EKS Cluster Autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html) as an Helm Add-on.


## [v1.3.0](https://github.com/ishuar/terraform-aws-eks/compare/v1.2.0...v1.3.0)

### Features

- Optional Use of Created KMS key for encryption in module resources.

## [v1.2.0](https://github.com/ishuar/terraform-eks/compare/v1.1.0...v1.2.0)

### Features

- Private cluster example updated with instance type to save costs.

### Bugs

- Fix Usage in Readme.
- Fix misleading variables descriptions.

## [v1.1.0](https://github.com/ishuar/terraform-eks/compare/v1.0.0...v1.1.0)

### Features

- Module outputs for oidc-connec
- Example for ALB with aws-alb-controller and external-dns
- Improved Docs

## [v1.0.0](https://github.com/ishuar/terraform-eks/commits/v1.0.0)

### Features

- Added Initial version of module.
- Documention
- Example for a Private Cluster