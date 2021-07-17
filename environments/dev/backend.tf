#LTM

terraform {
  backend "s3" {
    bucket         = "well-sparkitected-provision"
    key            = "terraform/dev"
    region         = "us-east-2"
    dynamodb_table = "well-sparkitected-provision"
    encrypt        = true
  }
}
