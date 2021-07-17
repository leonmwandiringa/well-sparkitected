

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name                 = "${var.project_name}_cluster_role"
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  tags                 = merge({
    "Name" = "${var.project_name}_cluster_role"
  }, var.tags)
  permissions_boundary = var.permissions_boundary
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = format("arn:%s:iam::aws:policy/AmazonEKSClusterPolicy", join("", data.aws_partition.current.*.partition))
  role       = aws_iam_role.default.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_service_policy" {
  policy_arn = format("arn:%s:iam::aws:policy/AmazonEKSServicePolicy", join("", data.aws_partition.current.*.partition))
  role       = aws_iam_role.default.name
}

data "aws_iam_policy_document" "cluster_elb_service_role" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInternetGateways",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSubnets"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cluster_elb_service_role" {
  count  = 1
  name   = "${var.project_name}_elb_service_role"
  role   = aws_iam_role.default.name
  policy = join("", data.aws_iam_policy_document.cluster_elb_service_role.*.json)
}