# Managed cache policy (no caching for API responses)
data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

# Managed origin request policy (forward everything except Host header)
data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  name = "Managed-AllViewerExceptHostHeader"
}

resource "aws_cloudfront_distribution" "tfp2_distribution" {

  origin {
    domain_name = split("/", replace(aws_apigatewayv2_api.tfp2_api.api_endpoint, "https://", ""))[0]
    origin_id   = "tfp2-api-origin"

    # Route requests to the prod stage
    origin_path = "/${aws_apigatewayv2_stage.tfp2_stage.name}"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = ""
  comment             = "CloudFront distribution for TFP2 API"

  # Attach WAF to CloudFront
  web_acl_id = aws_wafv2_web_acl.tfp2_waf.arn

  default_cache_behavior {
    # Allow all CRUD methods
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "tfp2-api-origin"

    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Project     = "TFP2"
    Environment = "prod"
  }

}
