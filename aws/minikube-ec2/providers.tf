terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
}

provider "aws" {
  region = var.region

  # Allows terraform plan to run without being authenticated to the AWS CLI
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
