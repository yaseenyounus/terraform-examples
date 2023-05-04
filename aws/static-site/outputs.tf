output "cloudfront_endpoint" {
  value = "https://${aws_cloudfront_distribution.cloudfront.domain_name}"
}
