
#network outputs
output "aws_vpc" {
  value = module.network.aws_vpc
}

output "aws_internet_gateway" {
  value = module.network.aws_internet_gateway
}

output "aws_security_group" {
  value = module.network.aws_security_group
}

output "aws_public_subnet" {
  value = module.network.aws_public_subnet
}

output "aws_public_subnets" {
  value = module.network.aws_public_subnets
}

output "aws_private_subnet" {
  value = module.network.aws_private_subnet
}

output "aws_private_subnets" {
  value = module.network.aws_private_subnets
}

output "aws_nat_gateway_count" {
  value = module.network.aws_nat_gateway_count
}

output "aws_nat_gateway_ids" {
  value = module.network.aws_nat_gateway_ids
}
output "aws_eip_nat_ips" {
  value = module.network.aws_eip_nat_ips
}


///////eks output/////////
output "eks_cluster_security_group_id" {
  description = "ID of the EKS cluster Security Group"
  value       = module.eks_cluster.security_group_id
}

output "eks_cluster_security_group_arn" {
  description = "ARN of the EKS cluster Security Group"
  value       = module.eks_cluster.security_group_arn
}

output "eks_cluster_security_group_name" {
  description = "Name of the EKS cluster Security Group"
  value       = module.eks_cluster.security_group_name
}

output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = module.eks_cluster.eks_cluster_id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks_cluster.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the cluster"
  value       = module.eks_cluster.eks_cluster_version
}

output "eks_cluster_identity_oidc_issuer" {
  description = "The OIDC Identity issuer for the cluster"
  value       = module.eks_cluster.eks_cluster_identity_oidc_issuer
}

output "eks_cluster_managed_security_group_id" {
  description = "Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads"
  value       = module.eks_cluster.eks_cluster_managed_security_group_id
}

output "eks_node_group_role_arn" {
  description = "ARN of the worker nodes IAM role"
  value       = module.eks_node_group.eks_node_group_role_arn
}

output "eks_node_group_role_name" {
  description = "Name of the worker nodes IAM role"
  value       = module.eks_node_group.eks_node_group_role_name
}

output "eks_node_group_id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon"
  value       = module.eks_node_group.eks_node_group_id
}

output "eks_node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = module.eks_node_group.eks_node_group_arn
}

output "eks_node_group_resources" {
  description = "List of objects containing information about underlying resources of the EKS Node Group"
  value       = module.eks_node_group.eks_node_group_resources
}

output "eks_node_group_status" {
  description = "Status of the EKS Node Group"
  value       = module.eks_node_group.eks_node_group_status
}
////////////////////////////////////////////

/////bucket outputs/////
output "bucket_id" {
  value = module.nlb_access_logs.bucket_id
}
////////////////

///////apigateway cloudwatch log group
output "cloudwatch_id" {
  value       = aws_cloudwatch_log_group.default.arn
  description = "cloudwatch"
}
////////////////////////////////