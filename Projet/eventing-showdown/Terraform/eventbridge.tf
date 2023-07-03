resource "aws_cloudwatch_event_bus" "eventbridge_test" {
    name = "eventbridge_test"
}

resource "aws_cloudwatch_event_rule" "generator_eventbridge_rule" {
    name = "forward-generator-events-eventbridge"
    description = "eventbridge example to forward generator function to receiving function"

    event_bus_name = aws_cloudwatch_event_bus.eventbridge_test.name
    event_pattern = jsonencode({
        source = ["test.lambda"],
        detail-type = ["Me Lambda Payload"]
    })

    tags = var.tags
}

resource "aws_cloudwatch_event_target" "generator_eventbridge_target" {
    arn = aws_lambda_function.response_eventbridge.arn
    rule = aws_cloudwatch_event_rule.generator_eventbridge_rule.name
    event_bus_name = aws_cloudwatch_event_bus.eventbridge_test.name
}
