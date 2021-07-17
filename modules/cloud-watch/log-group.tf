resource "aws_cloudwatch_log_group" "default" {
  name = "${lower(replace(var.project_name, "_", "-"))}-log-group"
  retention_in_days = var.retention_in_days

  tags = merge({
    "Name" = "${var.project_name}_log_group"
  },
  var.tags)
}