#LTM

module "network" {
  source                     = "../../modules/network"
  global_tags                = var.global_tags
  vpc_cidr_block             = var.vpc_cidr_block
  default_sg_rules_ingress   = var.default_sg_rules_ingress
  default_sg_rules_egress    = var.default_sg_rules_egress
  vpc_cidr_base              = var.vpc_cidr_base
  az_count                   = var.az_count
  aws_azs                    = var.aws_azs
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_subnet_cidrs       = var.private_subnet_cidrs
  project_name               = "${var.global_tags.Project}_${var.global_tags.Environment}"
}

# module "apigcloudwatch" {
#   source = "../../modules/cloud-watch"
#   retention_in_days = var.retention_in_days
#   project_name = "${var.global_tags.Project}_${var.global_tags.Environment}_api_gateway"
#   tags = var.global_tags
# }

module "data_lake" {
  source                      = "../../modules/s3"
  bucket_name                 = var.bucket_name
  bucket_acl                  = var.bucket_acl
  enable_bucket_versioning    = var.enable_bucket_versioning
  encryption_algorithm        = var.encryption_algorithm
  project_name                = "${var.global_tags.Project}_${var.global_tags.Environment}"
  tags                        = var.global_tags
}

module "eks_cluster" {
  source = "../../modules/eks-cluster"

  region                       = var.aws_region
  vpc_id                       = module.network.aws_vpc
  subnet_ids                   = concat(module.network.aws_public_subnets, module.network.aws_private_subnets)
  kubernetes_version           = var.kubernetes_version
  local_exec_interpreter       = var.local_exec_interpreter #should be nullified when running on the runner or unix based kernel 
  oidc_provider_enabled        = var.oidc_provider_enabled
  enabled_cluster_log_types    = var.enabled_cluster_log_types
  cluster_log_retention_period = var.cluster_log_retention_period

  project_name               = "${var.global_tags.Project}_${var.global_tags.Environment}"
  tags = var.global_tags
}


data "null_data_source" "wait_for_cluster_and_kubernetes_configmap" {
  inputs = {
    cluster_name             = module.eks_cluster.eks_cluster_id
    kubernetes_config_map_id = module.eks_cluster.kubernetes_config_map_id
  }
}

module "eks_node_group" {
  source  = "../../modules/eks-node-group"
  subnet_ids        = module.network.aws_private_subnets
  cluster_name      = data.null_data_source.wait_for_cluster_and_kubernetes_configmap.outputs["cluster_name"]
  instance_types    = var.instance_types
  desired_size      = var.desired_size
  min_size          = var.min_size
  max_size          = var.max_size
  kubernetes_labels = var.kubernetes_labels
  disk_size         = var.disk_size

  project_name               = "${var.global_tags.Project}_${var.global_tags.Environment}"
  tags = var.global_tags
}
