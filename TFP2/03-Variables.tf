# General
variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

# Lambda
variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "tfp2-serverless-api-handler"
}

variable "lambda_runtime" {
  description = "Runtime environment for Lambda"
  type        = string
  default     = "python3.13"
}

variable "lambda_handler" {
  description = "Handler for Lambda function"
  type        = string
  default     = "handler.lambda_handler"
}

# API Gateway
variable "api_name" {
  description = "Name of the API Gateway REST API"
  type        = string
  default     = "tfp2-serverless-api"
}

# DynamoDB
variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "tfp2-items"
}

variable "dynamodb_partition_key" {
  description = "Partition key for DynamoDB table"
  type        = string
  default     = "id"
}

# IAM
variable "lambda_role_name" {
  description = "IAM role name for Lambda execution"
  type        = string
  default     = "tfp2-lambda-exec-role"
}
