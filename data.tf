data "aws_caller_identity" "current_account" {}

data "aws_route53_zone" "route53_public_hosted_zone" {
  name         = var.custom_domain_name
  private_zone = false
}

data "aws_iam_policy_document" "home_s3_bucket_policy" {
  statement {
    sid    = "AllowCloudfrontToAccessBucket"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::tkmworks-home-${data.aws_caller_identity.current_account.account_id}/*"]
  }
}

data "aws_s3_bucket" "s3_origin_buckets" {
  for_each = var.hosted_websites
  bucket   = each.value.bucket_name
}

data "aws_cloudfront_cache_policy" "managed_cache_policy" {
  name = "Managed-CachingOptimized"
}