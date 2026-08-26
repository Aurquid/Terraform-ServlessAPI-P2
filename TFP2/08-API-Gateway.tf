# Create the HTTP API
resource "aws_apigatewayv2_api" "tfp2_api" {
  name          = "tfp2-serverless-api"
  protocol_type = "HTTP"
}

# Connect API Gateway to  Lambda
resource "aws_apigatewayv2_integration" "tfp2_integration" {
  api_id                 = aws_apigatewayv2_api.tfp2_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.tfp2_lambda.arn
  payload_format_version = "2.0"
}

# Define the route (GET /)
resource "aws_apigatewayv2_route" "tfp2_route" {
  api_id    = aws_apigatewayv2_api.tfp2_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.tfp2_integration.id}"
}

# Adds a $default route to catch all paths
resource "aws_apigatewayv2_route" "tfp2_default" {
  api_id    = aws_apigatewayv2_api.tfp2_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.tfp2_integration.id}"
}

# Deploy the API to a stage
resource "aws_apigatewayv2_stage" "tfp2_stage" {
  api_id      = aws_apigatewayv2_api.tfp2_api.id
  name        = "prod"
  auto_deploy = true
}

# Grant API Gateway permission to invoke Lambda
resource "aws_lambda_permission" "tfp2_apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tfp2_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.tfp2_api.execution_arn}/*/*"
}
# Handle HEAD requests
resource "aws_apigatewayv2_route" "tfp2_head" {
  api_id    = aws_apigatewayv2_api.tfp2_api.id
  route_key = "HEAD /"
  target    = "integrations/${aws_apigatewayv2_integration.tfp2_integration.id}"
}

# Handle OPTIONS request
resource "aws_apigatewayv2_route" "tfp2_options" {
  api_id    = aws_apigatewayv2_api.tfp2_api.id
  route_key = "OPTIONS /"
  target    = "integrations/${aws_apigatewayv2_integration.tfp2_integration.id}"
}

# CRUD ROUTES
resource "aws_apigatewayv2_route" "tfp2_post_items" {
  api_id    = aws_apigatewayv2_api.tfp2_api.id
  route_key = "POST /items"
  target    = "integrations/${aws_apigatewayv2_integration.tfp2_integration.id}"
}

resource "aws_apigatewayv2_route" "tfp2_get_items" {
  api_id    = aws_apigatewayv2_api.tfp2_api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.tfp2_integration.id}"
}

resource "aws_apigatewayv2_route" "tfp2_get_item" {
  api_id    = aws_apigatewayv2_api.tfp2_api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.tfp2_integration.id}"
}

resource "aws_apigatewayv2_route" "tfp2_put_item" {
  api_id    = aws_apigatewayv2_api.tfp2_api.id
  route_key = "PUT /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.tfp2_integration.id}"
}

resource "aws_apigatewayv2_route" "tfp2_delete_item" {
  api_id    = aws_apigatewayv2_api.tfp2_api.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.tfp2_integration.id}"
}
