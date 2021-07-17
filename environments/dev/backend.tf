#LTM

terraform {
  backend "s3" {
    bucket         = "{{RESOURCE_NAME}}"
    key            = "terraform/dev"
    region         = "{{AWS_REGION}}"
    dynamodb_table = "{{RESOURCE_NAME}}"
    encrypt        = true
  }
}
