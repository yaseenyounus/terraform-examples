terraform {
  # Terraform Remote State Configurations
  # https://developer.hashicorp.com/terraform/language/state/remote
  # https://developer.hashicorp.com/terraform/language/settings/backends/s3
  backend "s3" {
    # Change this remote state bucket name before deploying
    bucket = "tf-examples-state"

    key     = "aws/static-site/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
