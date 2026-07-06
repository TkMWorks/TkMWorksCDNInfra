resource "aws_acm_certificate" "tkmworks_dns_certificate" {
  domain_name       = "*.${var.custom_domain_name}"
  validation_method = "DNS"
  tags = merge({
    Name = "Certificate for ${var.custom_domain_name} Custom Domain."
  }, local.common_tags)
}

resource "aws_route53_record" "certificate_validation_records" {
  for_each = {
    for option in aws_acm_certificate.tkmworks_dns_certificate.domain_validation_options : option.domain_name => {
      name   = option.resource_record_name
      record = option.resource_record_value
      type   = option.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_public_hosted_zone.zone_id
}