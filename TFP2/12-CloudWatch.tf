# Log group for storing Lambda logs with retention control
resource "aws_cloudwatch_log_group" "tfp2_lambda_logs" {
  name              = "/aws/lambda/tfp2-serverless-api-handler"
  retention_in_days = 14

  tags = {
    Project = "TFP2"
    Owner   = "Alexis"
  }
}

# Metric filter that counts occurrences of "ERROR" in Lambda logs
resource "aws_cloudwatch_log_metric_filter" "tfp2_error_filter" {
  name           = "tfp2-error-filter"
  log_group_name = aws_cloudwatch_log_group.tfp2_lambda_logs.name

  pattern = "ERROR"

  metric_transformation {
    name      = "tfp2-error-count"
    namespace = "TFP2"
    value     = "1"
  }
}

# Alarm that triggers when the error metric exceeds the threshold
resource "aws_cloudwatch_metric_alarm" "tfp2_lambda_error_alarm" {
  alarm_name          = "tfp2-lambda-error-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "tfp2-error-count"
  namespace           = "TFP2"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  alarm_description = "Triggers when Lambda logs contain ERROR"
  alarm_actions     = []

  tags = {
    Project = "TFP2"
    Owner   = "Alexis"
  }
}
