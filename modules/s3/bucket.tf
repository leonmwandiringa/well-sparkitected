
resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  acl    = var.bucket_acl
  policy = data.aws_iam_policy_document.default.json

  versioning {
    enabled = var.enable_bucket_versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.encryption_algorithm
      }
    }
  }

  tags = merge(
    {
        Name = "${var.project_name}_${var.bucket_name}"
    },
    var.tags
  )
}