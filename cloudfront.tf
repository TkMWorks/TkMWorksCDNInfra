resource "aws_cloudfront_origin_access_control" "s3_bucket_oac" {
  name                              = "tkmworks-website-oac"
  description                       = "OAC for websites.tkmworks.co.in origins"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "tkmworks_cf_distribution" {
  enabled             = true
  comment             = "TkMWorks Centralized CloudFront Distribution"
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases = [
    "websites.${var.custom_domain_name}"
  ]
  dynamic "origin" {
    for_each = var.hosted_websites
    content {
      domain_name              = data.aws_s3_bucket.s3_origin_buckets[origin.key].bucket_regional_domain_name
      origin_id                = "S3-${data.aws_s3_bucket.s3_origin_buckets[origin.key].id}"
      origin_access_control_id = aws_cloudfront_origin_access_control.s3_bucket_oac.id
    }
  }
  origin {
    domain_name              = aws_s3_bucket.home_s3_bucket.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.home_s3_bucket.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_bucket_oac.id
  }
  dynamic "ordered_cache_behavior" {
    for_each = var.hosted_websites
    content {
      path_pattern           = "/${ordered_cache_behavior.value.path_prefix}/*"
      target_origin_id       = "S3-${data.aws_s3_bucket.s3_origin_buckets[ordered_cache_behavior.key].id}"
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["GET", "HEAD", "OPTIONS"]
      cached_methods         = ["GET", "HEAD"]
      compress               = true
      cache_policy_id        = data.aws_cloudfront_cache_policy.managed_cache_policy.id
    }
  }
  default_cache_behavior {
    target_origin_id       = "S3-${aws_s3_bucket.home_s3_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = data.aws_cloudfront_cache_policy.managed_cache_policy.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.tkmworks_dns_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  tags = merge(local.common_tags, {
    Name = "TkMWorks Centralized CloudFront Distribution"
  })
}