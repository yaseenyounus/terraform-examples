# Assigns local values for use
locals {
  account_id = data.aws_caller_identity.aws_account.account_id
  content_types = {
    ".html" = "text/html",
    ".css"  = "text/css",
    ".js"   = "text/javascript"
  }
}

# Creates S3 bucket to store static site files
resource "aws_s3_bucket" "content_bucket" {}

# Creates am S3 bucket policy for content_bucket
resource "aws_s3_bucket_policy" "content_bucket_policy" {
  bucket = aws_s3_bucket.content_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "cloudfront.amazonaws.com"
      },
      "Action" : "s3:GetObject",
      "Resource" : "arn:aws:s3:::${aws_s3_bucket.content_bucket.id}/*",
      "Condition" : {
        "StringEquals" : {
          "AWS:SourceArn" : "arn:aws:cloudfront::${local.account_id}:distribution/${aws_cloudfront_distribution.cloudfront.id}"
        }
      }
    }
  })
  depends_on = [aws_cloudfront_distribution.cloudfront]
}

# Enables versioning for the S3 bucket content_bucket
resource "aws_s3_bucket_versioning" "content_bucket_versioning" {
  bucket = aws_s3_bucket.content_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Copies the static files from site-assets to the S3 bucket
resource "aws_s3_object" "object" {
  for_each = fileset("site-assets", "**/*")

  bucket      = aws_s3_bucket.content_bucket.id
  key         = each.key
  source      = "site-assets/${each.value}"
  source_hash = filemd5("site-assets/${each.value}")

  # Updates the content type of the files accordingly
  content_type = lookup(
    local.content_types,
    regex("\\.[^.]+$", each.value),
    null
  )
}

# Creates a CloudFront Origin Access Control to access the static content S3 bucket
resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  name                              = "cloudfront_oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Creates a new CloudFront Distribution
resource "aws_cloudfront_distribution" "cloudfront" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.content_bucket.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_oac.id
    origin_id                = "s3_origin"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 3600
    max_ttl                = 86400
    min_ttl                = 0
    target_origin_id       = "s3_origin"
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
