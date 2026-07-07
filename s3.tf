resource "aws_s3_bucket" "home_s3_bucket" {
  bucket        = "tkmworks-home-${data.aws_caller_identity.current_account.account_id}"
  force_destroy = true
  tags = merge({
    Name = "TkMWorks Home Website Container Bucket"
  }, local.common_tags)
}

resource "aws_s3_bucket_policy" "homepage_s3bucket_policy" {
  bucket = aws_s3_bucket.home_s3_bucket.id
  policy = data.aws_iam_policy_document.home_s3_bucket_policy.json
}

resource "aws_s3_object" "html_page" {
  key           = "index.html"
  bucket        = aws_s3_bucket.home_s3_bucket.id
  source        = "./website/index.html"
  force_destroy = true
  etag          = filemd5("./website/index.html")
  content_type  = "text/html"
  tags = merge(local.common_tags, {
    Name = "TkMWorks Home Page HTML File"
  })
}

resource "aws_s3_object" "javascript_file" {
  key           = "script.js"
  bucket        = aws_s3_bucket.home_s3_bucket.id
  source        = "./website/script.js"
  force_destroy = true
  etag          = filemd5("./website/script.js")
  content_type  = "application/javascript"
  tags = merge(local.common_tags, {
    Name = "TkMWorks Home Page Javascript File"
  })
}

resource "aws_s3_object" "css_stylesheet" {
  key           = "style.css"
  bucket        = aws_s3_bucket.home_s3_bucket.id
  source        = "./website/style.css"
  force_destroy = true
  etag          = filemd5("./website/style.css")
  content_type  = "text/css"
  tags = merge(local.common_tags, {
    Name = "TkMWorks Home Page CSS Stylesheet"
  })
}

resource "aws_s3_object" "website_logo" {
  key           = "logo.png"
  bucket        = aws_s3_bucket.home_s3_bucket.id
  source        = "./website/logo.png"
  force_destroy = true
  etag          = filemd5("./website/logo.png")
  content_type  = "image/png"
  tags = merge(local.common_tags, {
    Name = "TkMWorks Home Page Website Logo"
  })
}