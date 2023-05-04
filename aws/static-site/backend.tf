terraform {
  backend "s3" {
    # Change this remote state bucket name before deploying
    bucket = "tf-examples-state"

    key     = "aws/static-site/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
