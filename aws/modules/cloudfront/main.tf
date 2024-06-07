resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  enabled             = true
  comment             = var.description
  is_ipv6_enabled     = var.is_ipv6_enabled
  default_root_object = var.default_root_object
  web_acl_id          = var.web_acl_id
  aliases             = var.aliases

  dynamic "origin" {
    for_each = var.origin_type == "elb" ? [1] : []

    content {
      domain_name = var.clb_dns_name
      origin_id   = "ELBOriginID"

      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = var.origin_protocol_policy
        origin_ssl_protocols   = var.origin_ssl_protocols
      }
    }
  }

  dynamic "origin" {
    for_each = var.origin_type == "s3" ? [1] : []

    content {
      domain_name              = "${var.s3_bucket_name}.s3.${var.aws_region}.amazonaws.com"
      origin_id                = "S3OriginID"
      origin_access_control_id = var.origin_access_control_id

      dynamic "s3_origin_config" {
        for_each = length(var.origin_access_identity) > 0 ? [1] : []

        content {
          origin_access_identity = var.origin_access_identity
        }
      }
    }
  }

  default_cache_behavior {
    allowed_methods            = var.allowed_methods
    cached_methods             = var.cached_methods
    target_origin_id           = var.origin_type == "elb" ? "ELBOriginID" : "S3OriginID"
    response_headers_policy_id = var.response_headers_policy_id
    cache_policy_id            = var.cache_policy_id
    compress                   = var.default_cache_behavior_compress

    dynamic "forwarded_values" {
      for_each = length(var.cache_policy_id) == 0 ? [1] : []

      content {
        query_string = var.forwarded_query_string
        headers      = var.forwarded_headers

        cookies {
          forward           = var.forwarded_qcookies_string
          whitelisted_names = var.whitelisted_cookies
        }
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

  dynamic "custom_error_response" {
    for_each = length(flatten([var.custom_error_response])[0]) > 0 ? flatten([var.custom_error_response]) : []

    content {
      error_code = custom_error_response.value["error_code"]

      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
    }
  }

}
