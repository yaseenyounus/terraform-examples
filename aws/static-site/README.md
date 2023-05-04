# Terraform AWS Static Site

## Overview

This Terraform AWS code sample demonstrates how to configure and deploy a static site using Simple Storage Service (S3) and CloudFront.

## Real-world Example

When working with static sites, it's more efficient to host the assets in S3 buckets, rather than a server or container that's always running. To achieve this, we store the assets in an S3 bucket, and create a CloudFront Distribution that uses the S3 bucket as its origin to retrieve, serve, and cache content.

## Requirements

- [Terraform v1.4.6](https://developer.hashicorp.com/terraform/downloads)
- AWS Account

## AWS Services Utilized

- CloudFront
- S3

## Deploying

- Authenticate to an AWS account via a Command Line Interface (CLI).
- Navigate to this `aws/static-site` directory.
- Do you want to use [Terraform Remote State](https://developer.hashicorp.com/terraform/language/state/remote)?
  - YES
    - [Create a new S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html) using the AWS CLI or console:
      - CLI: `aws s3 mb s3://unique-bucket-name-tf-state`
      - Console: AWS &#8594; S3 &#8594; `Create bucket` &#8594; Fill in required fields &#8594; `Create bucket`
    - In the `backend.tf` file, update the bucket name to the bucket you created. This S3 bucket will contain the [remote Terraform state](https://developer.hashicorp.com/terraform/language/settings/backends/s3).
  - NO 
    - Comment the contents of `backend.tf` out and proceed
- `terraform init` to initialize and prepare the Terraform directory.
- `terraform validate` to check if the Terraform configuration is valid.
- `terraform plan` to preview the actions that Terraform will perform.
- `terraform apply` deploys (create/update/destroy) the infrastructure.

## Outputs

After successful deployment, Terraform will output:

- CloudFront Distribution Endpoint

## Testing

- To test that the static site is running, we can use either the CloudFront Distribution endpoint.
- The static site contains two files: `/index.html` and `/error.html`.
  - `/index.html` is served whenever you visit the root path or `/index.html`.
