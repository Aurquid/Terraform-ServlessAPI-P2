# DynamoDB Table
resource "aws_dynamodb_table" "tfp2_table" {
  name         = "tfp2-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Project = "TFP2"
    Owner   = "Alexis"
  }
}

# IAM Policy allowing Lambda to read/write DynamoDB
resource "aws_iam_policy" "tfp2_dynamodb_policy" {
  name        = "tfp2-dynamodb-policy"
  description = "Allow Lambda to read/write items in DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.tfp2_table.arn
      }
    ]
  })
}

# Attach the policy to your Lambda role
resource "aws_iam_role_policy_attachment" "tfp2_lambda_dynamodb_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.tfp2_dynamodb_policy.arn
}