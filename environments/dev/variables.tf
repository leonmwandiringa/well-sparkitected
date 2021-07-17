#Leon Mwandiringa


///////// Global ///////
variable "global_tags" {
  description = "All Cloud network global tags for Leon Mwandiringa"
  type = map(string)
  default = {
    "Author" = "Leon Mwandiringa"
    "Environment" = "staging"
    "Project" = "well-sparkitected"
    "Provisioner" = "Terraform"
  }
}

////////// VPC CONFIG ///////
variable "aws_region" {
    default = "eu-west-2"
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



///db variables

variable "database_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created  and username"
  default = "brsk_core"
}

variable "database_identifier" {
  type = string
  description = "dbname"
  default     = "brsk-core"
}

variable "database_password" {
  type        = string
  default     = "fds038KPy317GD"
  description = "(Required unless a snapshot_identifier or replicate_source_db is provided) Password for the master DB user"
}

variable "database_port" {
  type        = number
  description = "Database port (_e.g._ `3306` for `MySQL`). Used in the DB Security Group to allow access to the DB instance from the provided `security_group_ids`"
  default = 5432
}

variable "deletion_protection" {
  type        = bool
  description = "Set to true to enable deletion protection on the RDS instance"
  default     = false
}

variable "multi_az" {
  type        = bool
  description = "Set to true if multi AZ deployment must be supported"
  default     = false
}

variable "storage_type" {
  type        = string
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  default     = "gp2"
}

variable "storage_encrypted" {
  type        = bool
  description = "(Optional) Specifies whether the DB instance is encrypted. The default is false if not specified"
  default     = false
}

variable "iops" {
  type        = number
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'. Default is 0 if rds storage type is not 'io1'"
  default     = 0
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in GBs"
  default = 10
}

variable "max_allocated_storage" {
  type        = number
  description = "The upper limit to which RDS can automatically scale the storage in GBs"
  default     = 50
}

variable "engine" {
  type        = string
  description = "Database engine type"
  default = "postgres"
}

variable "engine_version" {
  type        = string
  description = "Database engine version, depends on engine type"
  default = "12.5"
}


variable "instance_class" {
  type        = string
  description = "Class of RDS instance"
  default = "db.t2.micro"
}

variable "publicly_accessible" {
  type        = bool
  description = "Determines if database can be publicly available (NOT recommended)"
  default     = true
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Allow automated minor version upgrade (e.g. from Postgres 9.5.3 to Postgres 9.5.4)"
  default     = true
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Allow major version upgrade"
  default     = false
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = true #need to change later
}

variable "maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' UTC "
  default     = "Mon:03:00-Mon:04:00"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "If true (default), no snapshot will be made before deleting DB"
  default     = false
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Copy tags from DB to a snapshot"
  default     = true
}

variable "backup_retention_period" {
  type        = number
  description = "Backup retention period in days. Must be > 0 to enable backups"
  default     = 0 #need to change to 7 in prod
}

variable "backup_window" {
  type        = string
  description = "When AWS can perform DB snapshots, can't overlap with maintenance window"
  default     = "00:00-03:00"
}

variable "final_snapshot_identifier" {
  type        = string
  description = "Final snapshot identifier e.g.: some-db-final-snapshot-2019-06-26-06-05"
  default     = ""
}

variable "parameter_group_name" {
  type        = string
  description = "Name of the DB parameter group to associate"
  default     = ""
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the existing KMS key to encrypt storage"
  default     = ""
}

variable "performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether Performance Insights are enabled."
}

variable "performance_insights_kms_key_id" {
  type        = string
  default     = null
  description = "The ARN for the KMS key to encrypt Performance Insights data. Once KMS key is set, it can never be changed."
}

variable "performance_insights_retention_period" {
  type        = number
  default     = 7
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = []
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
}

variable "ca_cert_identifier" {
  type        = string
  description = "The identifier of the CA certificate for the DB instance"
  default     = "rds-ca-2019"
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. Valid Values are 0, 1, 5, 10, 15, 30, 60."
  default     = "0"
}

variable "monitoring_role_arn" {
  type        = string
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  default     = null
}

variable "db_sg_rules_egress" {
  description = "List of maps of db rules egress"
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

variable "db_sg_rules_ingress" {
  description = "List of maps of db rules ingress"
  type        = list(map(string))

  default = [
    {
      description = "HTTP"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
///////////////////////////////////////////////////////////


//////elb logging bucket////////////////////

variable "bucket_name" {
  default = "brsk-staging-logs"
}
variable "bucket_acl" {
  default = "private"
}
variable "enable_bucket_versioning" {
  default = true
}
variable "encryption_algorithm" {
  default = "AES256"
}
variable "enable_lifecyle_rule" {
  default = true
}

variable "one_zone_ia_transition_days" {
  default = 30
}

variable "glacier_transition_days" {
  default = 60
}

variable "expiration_days" {
  type        = number
  description = "Number of days after which to expunge s3 logs"
  default     = 90
}
///////////////////////////////////////////////


////////cloudwatch//////////////////

variable "retention_in_days" {
  default = 60
  description = "number of days for retention"
}

///////////////////////////