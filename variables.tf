variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project"
  default     = "TkMWorksCDNInfra"
}

variable "project_owner" {
  type        = string
  description = "Owner of resources in the project"
  default     = "TkM"
}

variable "custom_domain_name" {
  type        = string
  description = "Custom Domain Name for hosting"
  default     = "tkmworks.co.in"
}

variable "hosted_websites" {
  description = <<-EOT
  Map of sites to serve behind this distribution. Key is an internal
  identifier (used as origin_id), value defines the S3 bucket and the
  URL path prefix it should be served under.
  Set is_default = true on exactly one site to make it the catch-all
  behavior for requests that don't match any path pattern.
EOT
  type = map(object({
    bucket_name = string
    path_prefix = string
  }))
}