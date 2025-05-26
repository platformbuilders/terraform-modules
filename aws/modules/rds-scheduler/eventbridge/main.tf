locals {
  # Convert BRT times to UTC (BRT is UTC-3)
  timezone_info = var.timezone_description
}

# Create EventBridge rules for each RDS instance
resource "aws_cloudwatch_event_rule" "start_rds" {
  for_each = var.rds_instances

  name                = "start-rds-${each.value.instance_id}"
  description         = "Start RDS instance ${each.value.instance_id} (${local.timezone_info})"
  schedule_expression = var.start_time_cron
}

resource "aws_cloudwatch_event_target" "start_rds" {
  for_each = var.rds_instances

  rule      = aws_cloudwatch_event_rule.start_rds[each.key].name
  target_id = "StartRDSInstance-${each.value.instance_id}"
  arn       = var.lambda_function_arn

  input = jsonencode({
    action         = "start"
    db_instance_id = each.value.instance_id
  })
}

resource "aws_cloudwatch_event_rule" "stop_rds" {
  for_each = var.rds_instances

  name                = "stop-rds-${each.value.instance_id}"
  description         = "Stop RDS instance ${each.value.instance_id} (${local.timezone_info})"
  schedule_expression = var.stop_time_cron
}

resource "aws_cloudwatch_event_target" "stop_rds" {
  for_each = var.rds_instances

  rule      = aws_cloudwatch_event_rule.stop_rds[each.key].name
  target_id = "StopRDSInstance-${each.value.instance_id}"
  arn       = var.lambda_function_arn

  input = jsonencode({
    action         = "stop"
    db_instance_id = each.value.instance_id
  })
}

# Permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge_start" {
  for_each = var.rds_instances

  statement_id  = "AllowEventBridgeStart-${each.value.instance_id}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_rds[each.key].arn
}

resource "aws_lambda_permission" "allow_eventbridge_stop" {
  for_each = var.rds_instances

  statement_id  = "AllowEventBridgeStop-${each.value.instance_id}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_rds[each.key].arn
} 