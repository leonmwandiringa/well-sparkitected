

locals {
  aws_policy_prefix = format("arn:%s:iam::aws:policy", join("", data.aws_partition.current.*.partition))
}

data "aws_partition" "current" {
  count = 1
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "amazon_eks_worker_node_autoscale_policy" {
  count = var.worker_role_autoscale_iam_enabled ? 1 : 0
  statement {
    sid = "AllowToScaleEKSNodeGroupAutoScalingGroup"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "amazon_eks_worker_node_autoscale_policy" {
  count  = var.worker_role_autoscale_iam_enabled ? 1 : 0
  name   = "${var.project_name}_cluster_nodes_scaling_policy"
  policy = join("", data.aws_iam_policy_document.amazon_eks_worker_node_autoscale_policy.*.json)
}

resource "aws_iam_role" "default" {
  name                 = "${var.project_name}_cluster_nodes_role"
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role.*.json)
  permissions_boundary = var.permissions_boundary
  tags                 = merge({
    "Name" = "${var.project_name}_cluster_role"
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  count      = 1
  policy_arn = format("%s/%s", local.aws_policy_prefix, "AmazonEKSWorkerNodePolicy")
  role       = aws_iam_role.default.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_autoscale_policy" {
  count      = var.worker_role_autoscale_iam_enabled ? 1 : 0
  policy_arn = join("", aws_iam_policy.amazon_eks_worker_node_autoscale_policy.*.arn)
  role       = aws_iam_role.default.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  count      = 1
  policy_arn = format("%s/%s", local.aws_policy_prefix, "AmazonEKS_CNI_Policy")
  role       = aws_iam_role.default.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  count      = 1
  policy_arn = format("%s/%s", local.aws_policy_prefix, "AmazonEC2ContainerRegistryReadOnly")
  role       = aws_iam_role.default.name
}

resource "aws_iam_role_policy_attachment" "existing_policies_for_eks_workers_role" {
  for_each   = length(var.existing_workers_role_policy_arns) > 0 ? toset(var.existing_workers_role_policy_arns) : []
  policy_arn = each.value
  role       = aws_iam_role.default.name
}