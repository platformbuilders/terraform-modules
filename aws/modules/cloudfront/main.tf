resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  enabled             = true
  is_ipv6_enabled     = var.is_ipv6_enabled
  default_root_object = var.default_root_object

  dynamic "origin" {
    for_each = var.origin_type == "elb" ? [1] : []

    content {
      domain_name = var.clb_dns_name
      origin_id   = "ELBOriginID"

      custom_origin_config {
        http_port                = 80
        https_port               = 443
        origin_protocol_policy   = var.origin_protocol_policy
        origin_ssl_protocols     = var.origin_ssl_protocols
      }
    }
  }

  dynamic "origin" {
    for_each = var.origin_type == "s3" ? [1] : []

    content {
      domain_name = "${var.s3_bucket_name}.s3.amazonaws.com"
      origin_id   = "S3OriginID"

      s3_origin_config {
        origin_access_identity = var.origin_access_identity
      }
    }
  }

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = var.origin_type == "elb" ? "ELBOriginID" : "S3OriginID"

    forwarded_values {
      query_string = var.forwarded_query_string

      cookies {
        forward = var.forwarded_cookies
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.use_acm_certificate ? var.acm_certificate_arn : null
    ssl_support_method             = var.use_acm_certificate ? "sni-only" : null
    minimum_protocol_version       = var.use_acm_certificate ? "TLSv1.2_2019" : null
    cloudfront_default_certificate = !var.use_acm_certificate
  }
  
}
