variable "aws_region" {
  description = "AWS region where the resources will be deployed"
  type        = string
}

variable "origin_type" {
  description = "Type of the origin. Valid values are 's3' or 'elb'."
  type        = string
}

variable "clb_dns_name" {
  description = "DNS name of the Classic Load Balancer. Required if origin_type is 'elb'."
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket. Required if origin_type is 's3'."
  type        = string
  default     = ""
}

variable "origin_access_identity" {
  description = "The CloudFront origin access identity to associate with the origin. Required if origin_type is 's3'."
  type        = string
  default     = ""
}

variable "origin_protocol_policy" {
  description = "The origin protocol policy to apply to your origin. Valid values are 'http-only', 'https-only', or 'match-viewer'."
  type        = string
  default     = "http-only"
}

variable "origin_ssl_protocols" {
  description = "A list of SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS."
  type        = list(string)
  default     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
}

variable "is_ipv6_enabled" {
  description = "State whether IPv6 is enabled for the distribution."
  type        = bool
  default     = false
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return when an end user requests the root URL."
  type        = string
  default     = "login"
}

variable "allowed_methods" {
  description = "List of allowed methods (e.g., GET, PUT, POST, DELETE, HEAD) for CloudFront to process and forward to your origin."
  type        = list(string)
  default     = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
}

variable "cached_methods" {
  description = "List of cached methods (e.g., GET, HEAD)."
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "forwarded_query_string" {
  description = "Indicates whether you want CloudFront to forward query strings to the origin."
  type        = bool
  default     = false
}

variable "forwarded_cookies" {
  description = "Specifies which cookies to forward to the origin for this cache behavior: 'all', 'none' or 'whitelist'."
  type        = string
  default     = "none"
}

variable "viewer_protocol_policy" {
  description = "The viewer protocol policy for the default cache behavior. Valid values are 'allow-all', 'https-only', and 'redirect-to-https'."
  type        = string
  default     = "allow-all"
}

variable "min_ttl" {
  description = "The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront forwards another request to your origin."
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin."
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin."
  type        = number
  default     = 86400
}

variable "price_class" {
  description = "The price class for this distribution. Valid values are 'PriceClass_100', 'PriceClass_200', and 'PriceClass_All'."
  type        = string
  default     = "PriceClass_100"
}

variable "geo_restriction_type" {
  description = "The method that you want to use to restrict distribution of your content by country: 'none', 'whitelist', or 'blacklist'."
  type        = string
  default     = "none"
}

variable "use_default_cloudfront_certificate" {
  description = "Specifies whether you want CloudFront to use its default certificate."
  type        = bool
  default     = true
}

variable "use_acm_certificate" {
  description = "Set to true to use an ACM certificate. If false, the default CloudFront certificate will be used."
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "The ARN of the AWS Certificate Manager certificate to use with CloudFront. Required if use_acm_certificate is true."
  type        = string
  default     = ""
}
