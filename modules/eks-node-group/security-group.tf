

resource "aws_security_group" "remote_access" {
  count       = local.need_remote_access_sg ? 1 : 0
  name        = "${var.project_name}_cluster_node_group_remoteaccess_sg"
  description = "Allow SSH access to all nodes in the nodeGroup"
  vpc_id      = data.aws_eks_cluster.this[0].vpc_config[0].vpc_id
  tags        = merge(var.tags, { "Name" = "${var.project_name}_cluster_node_group_remoteaccess_sg" })
}

resource "aws_security_group_rule" "remote_access_public_ssh" {
  #bridgecrew:skip=BC_AWS_NETWORKING_1:Skipping `Port Security 0.0.0.0:0 to 22` check because we want to allow SSH access to all nodes in the nodeGroup
  count       = local.need_remote_access_sg && length(var.source_security_group_ids) == 0 ? 1 : 0
  description = "Allow SSH access to nodes from anywhere"
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = join("", aws_security_group.remote_access.*.id)
}

resource "aws_security_group_rule" "remote_access_source_sgs_ssh" {
  for_each    = local.need_remote_access_sg ? toset(var.source_security_group_ids) : []
  description = "Allow SSH access to nodes from security group"
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22

  security_group_id        = aws_security_group.remote_access[0].id
  source_security_group_id = each.value
}