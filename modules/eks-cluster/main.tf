

locals {
  cluster_encryption_config = {
    resources        = var.cluster_encryption_config_resources
    provider_key_arn = var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? join("", aws_kms_key.cluster.*.arn) : var.cluster_encryption_config_kms_key_id
  }
}

data "aws_partition" "current" {
  count = 1
}

resource "aws_cloudwatch_log_group" "default" {
  count             = length(var.enabled_cluster_log_types) > 0 ? 1 : 0
  name              = "/aws/eks/${var.project_name}/cluster"
  retention_in_days = var.cluster_log_retention_period
  tags              = merge({
    "Name" = "${var.project_name}_cluster_log_group"
  }, var.tags)
}

resource "aws_kms_key" "cluster" {
  count                   = var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
  description             = "EKS Cluster ${var.project_name} Encryption Config KMS Key"
  enable_key_rotation     = var.cluster_encryption_config_kms_key_enable_key_rotation
  deletion_window_in_days = var.cluster_encryption_config_kms_key_deletion_window_in_days
  policy                  = var.cluster_encryption_config_kms_key_policy
  tags                    = merge({
    "Name" = "${var.project_name}_cluster_kms_key"
  }, var.tags)
}

resource "aws_kms_alias" "cluster" {
  count         = var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
  name          = "${var.project_name}_cluster_kms_alias"
  target_key_id = join("", aws_kms_key.cluster.*.key_id)
}

resource "aws_eks_cluster" "default" {
  name                      = "${var.project_name}_cluster"
  tags                      = merge({
    "Name" = "${var.project_name}_cluster"
  }, var.tags)
  role_arn                  = aws_iam_role.default.arn
  version                   = var.kubernetes_version
  enabled_cluster_log_types = var.enabled_cluster_log_types

  dynamic "encryption_config" {
    for_each = var.cluster_encryption_config_enabled ? [local.cluster_encryption_config] : []
    content {
      resources = lookup(encryption_config.value, "resources")
      provider {
        key_arn = lookup(encryption_config.value, "provider_key_arn")
      }
    }
  }

  vpc_config {
    security_group_ids      = [join("", aws_security_group.default.*.id)]
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy,
    aws_iam_role_policy_attachment.amazon_eks_service_policy,
    aws_cloudwatch_log_group.default
  ]
}

resource "aws_iam_openid_connect_provider" "default" {
  url   = aws_eks_cluster.default.identity.0.oidc.0.issuer

  client_id_list = ["sts.amazonaws.com"]

  # it's thumbprint won't change for many years
  # https://github.com/terraform-providers/terraform-provider-aws/issues/10104
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}