#LTM


///////// Global ///////
variable "global_tags" {
  description = "All Cloud network global tags for Leon Mwandiringa"
  type = map(string)
  default = {
    "Author" = "Leon Mwandiringa"
    "Environment" = "dev"
    "Project" = "well-sparkitected"
    "Provisioner" = "Terraform"
  }
}

////////// VPC CONFIG ///////
variable "aws_region" {
    default = "us-east-2"
}
variable "aws_azs" {
  description = "comma separated string of availability zones in order of precedence"
  default     = "us-east-2a,us-east-2b"
}
variable "az_count" {
  description = "number of active availability zones in VPC"
  default     = "2"
}
variable "vpc_cidr_block" {
    default = "10.6.0.0/16"
}
variable "vpc_cidr_base" {
    default = "10.6"
}
variable "private_subnet_cidrs" {
  description = "CIDRs for the private subnets"
  default = {
    zone0 = ".1.0/24"
    zone1 = ".2.0/24"
    zone2 = ".3.0/24"
  }
}
variable "public_subnet_cidrs" {
  description = "CIDRs for the public subnets"
  default = {
    zone0 = ".4.0/24"
    zone1 = ".5.0/24"
    zone2 = ".6.0/24"
  }
}
variable "default_sg_rules_ingress" {
  description = "List of maps of default seurity group rules ingress"
  type        = list(map(string))

  default = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

variable "default_sg_rules_egress" {
  description = "List of maps of default seurity group rules egress"
  type        = list(map(string))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}


variable "vpc_instance_tenancy" {
  default = "default"
}
variable "vpc_enable_dns_support" {
  default = "true"
}
variable "vpc_enable_dns_hostnames" {
  default = "true"
}
variable "vpc_enable_classiclink" {
  default = "false"
}
///////////////////////////////////////////////////////////////////////

/////eks/////
variable "kubernetes_version" {
  type        = string
  default     = "1.19"
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = []
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}

variable "cluster_log_retention_period" {
  type        = number
  default     = 0
  description = "Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html."
}

variable "map_additional_aws_accounts" {
  description = "Additional AWS account numbers to add to `config-map-aws-auth` ConfigMap"
  type        = list(string)
  default     = []
}

variable "map_additional_iam_roles" {
  description = "Additional IAM roles to add to `config-map-aws-auth` ConfigMap"

  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "map_additional_iam_users" {
  description = "Additional IAM users to add to `config-map-aws-auth` ConfigMap"

  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "oidc_provider_enabled" {
  type        = bool
  default     = true
  description = "Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using `kiam` or `kube2iam`. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html"
}

variable "local_exec_interpreter" {
  type        = list(string)
  # default     = ["/bin/sh", "-c"]
  default = ["bash", "-c"]
  description = "shell to use for local_exec"
}

variable "disk_size" {
  type        = number
  description = "Disk size in GiB for worker nodes. Defaults to 20. Terraform will only perform drift detection if a configuration value is provided"
  default = 20
}

variable "instance_types" {
  type        = list(string)
  description = "Set of instance types associated with the EKS Node Group. Terraform will only perform drift detection if a configuration value is provided"
  default = ["t3.medium"]
}

variable "kubernetes_labels" {
  type        = map(string)
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
  default     = {}
}

#$##changing before deloyment
variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes"
  default = 1
}

variable "max_size" {
  type        = number
  description = "The maximum size of the AutoScaling Group"
  default = 3
}

variable "min_size" {
  type        = number
  description = "The minimum size of the AutoScaling Group"
  default = 1
}
///////////////////////////////////////////////////////////





////////cloudwatch//////////////////

variable "retention_in_days" {
  default = 60
  description = "number of days for retention"
}

///////////////////////////

////////////data lake //////////////////
variable "bucket_name" {
  default = "well-sparkitected"
  description = "data lake name"
}
variable "bucket_acl" {
  default = "private"
}
variable "enable_bucket_versioning" {
  default = false
}
variable "encryption_algorithm" {
  default = "AES256"
}
///////////////////////////////////////