# BRSK

locals {

  configured_launch_template_name    = var.launch_template_name == null ? "" : var.launch_template_name
  configured_launch_template_version = length(local.configured_launch_template_name) > 0 && length(compact([var.launch_template_version])) > 0 ? var.launch_template_version : ""

  generate_launch_template = local.features_require_launch_template && length(local.configured_launch_template_name) == 0
  use_launch_template      = local.features_require_launch_template || length(local.configured_launch_template_name) > 0

  launch_template_id = local.use_launch_template ? (length(local.configured_launch_template_name) > 0 ? data.aws_launch_template.this[0].id : aws_launch_template.default[0].id) : ""
  launch_template_version = local.use_launch_template ? (
    length(local.configured_launch_template_version) > 0 ? local.configured_launch_template_version :
    (
      length(local.configured_launch_template_name) > 0 ? data.aws_launch_template.this[0].latest_version : aws_launch_template.default[0].latest_version
    )
  ) : ""

  launch_template_ami = length(local.configured_ami_image_id) == 0 ? (local.features_require_ami ? data.aws_ami.selected[0].image_id : "") : local.configured_ami_image_id

  launch_template_vpc_security_group_ids = (
    local.need_remote_access_sg ?
    concat(data.aws_eks_cluster.this[0].vpc_config[*].cluster_security_group_id, aws_security_group.remote_access.*.id) : []
  )

  # launch_template_key = join(":", coalescelist(local.launch_template_vpc_security_group_ids, ["closed"]))
}

resource "aws_launch_template" "default" {

  count = 1
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.disk_size
      volume_type = var.disk_type
      kms_key_id  = var.launch_template_disk_encryption_enabled && length(var.launch_template_disk_encryption_kms_key_id) > 0 ? var.launch_template_disk_encryption_kms_key_id : null
      encrypted   = var.launch_template_disk_encryption_enabled
    }
  }

  name_prefix            = "${var.project_name}_"
  update_default_version = true

  # Never include instance type in launch template because it is limited to just one
  # https://docs.aws.amazon.com/eks/latest/APIReference/API_CreateNodegroup.html#API_CreateNodegroup_RequestSyntax
  image_id = local.launch_template_ami == "" ? null : local.launch_template_ami
  key_name = local.have_ssh_key ? var.ec2_ssh_key : null

  dynamic "tag_specifications" {
    for_each = var.resources_to_tag
    content {
      resource_type = tag_specifications.value
      tags          = local.node_tags
    }
  }

  metadata_options {
    http_put_response_hop_limit = 2
    http_endpoint = "enabled"
  }

  vpc_security_group_ids = local.launch_template_vpc_security_group_ids
  user_data              = local.userdata
  tags                   = local.node_group_tags
}

data "aws_launch_template" "this" {
  count = length(local.configured_launch_template_name) > 0 ? 1 : 0

  name = local.configured_launch_template_name
}