data "aws_route53_zone" "route53_public_hosted_zone" {
  name         = var.custom_domain_name
  private_zone = false
}