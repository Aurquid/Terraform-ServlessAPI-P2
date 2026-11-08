# Build handler.zip from handler.py automatically
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/handler.py"
  output_path = "${path.module}/lambda/handler.zip"
}

# Lambda Function Configuration
resource "aws_lambda_function" "tfp2_lambda" {
  function_name    = var.lambda_name
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  filename         = data.archive_file.lambda_zip.output_path
  role             = aws_iam_role.lambda_exec_role.arn
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.tfp2_table.name
    }
  }
}
