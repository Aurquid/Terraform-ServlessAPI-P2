output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.tfp2_lambda.function_name
}

output "api_gateway_invoke_url" {
  description = "Invoke URL for the API Gateway HTTP API"
  value       = aws_apigatewayv2_api.tfp2_api.api_endpoint
}

output "cloudfront_domain_name" {
  description = "Domain name for the CloudFront distribution"
  value       = aws_cloudfront_distribution.tfp2_distribution.domain_name
}
output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.tfp2_waf.arn
}
output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.tfp2_table.name
}
