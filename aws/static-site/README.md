# Terraform AWS Static Site

## Overview

This Terraform AWS code samples demonstrates how to configure and deploy a static site using S3 and CloudFront.

## Real-world Example

When working with static sites, it's more efficient to host the assets in an S3 Bucket, rather than a server or container that is always running. To achieve this, we store the assets in an S3 Bucket, and create a CloudFront Distribution that uses the S3 Bucket as its origin to retrieve, serve, and cache content.

## AWS Services Utilized

- CloudFront
- S3

## Deploying

- Authenticate to an AWS account via a Command Line Interface (CLI).
- Navigate to this `aws/static-site` directory.
- In the `backend.tf` file, change the bucket name to something unique. This S3 bucket will contain the [remote Terraform state](https://developer.hashicorp.com/terraform/language/settings/backends/s3). Otherwise for local state, comment the contents of `backend.tf` out.
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