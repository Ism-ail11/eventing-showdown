# SQS

data "archive_file" "sqs_response_zip" {
    type = "zip"
    source_file = "../Python Scripts/sqs_response.py"
    output_path = "${path.module}/lambda/sqs_response.zip"
}

resource "aws_lambda_function" "response_sqs" {
    filename = "${path.module}/lambda/sqs_response.zip"
    function_name = "sqs_response"
    role = aws_iam_role.response_role.arn

    handler = "sqs_response.lambda_handler"
    runtime = "python3.10"
}

resource "aws_iam_role" "response_role" {
    name = "sqs_response_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = {
            Effect = "allow",
            Action = "sts:AssumeRole",
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }
    })

    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "sqs_response_attachment" {
    role = aws_iam_role.response_role.name
    policy_arn = aws_iam_policy.sqs_response_policy.arn
}

resource "aws_lambda_event_source_mapping" "sqs_response_mapping" {
    function_name = aws_lambda_function.response_sqs.arn
    event_source_arn = aws_sqs_queue.sqs_test.arn
    batch_size = 1
    enabled = true
}

# Eventbridge

data "archive_file" "eventbridge_response_zip" {
    type = "zip"
    source_file = "../Python Scripts/eventbridge_response.py"
    output_path = "${path.module}/lambda/eventbridge_response.zip"
}

resource "aws_lambda_function" "response_eventbridge" {
    filename = "${path.module}/lambda/eventbridge_response.zip"
    function_name = "eventbridge_response"
    role = aws_iam_role.response_role.arn

    handler = "eventbridge_response.lambda_handler"
    runtime = "python3.10"
}

resource "aws_lambda_permission" "eventbridge_permission" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.response_eventbridge.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.generator_eventbridge_rule.arn
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
    role = aws_iam_role.response_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Kinesis Data Streams

data "archive_file" "kinesis_streams_response_zip" {
    type = "zip"
    source_file = "../Python Scripts/kinesis_streams_response.py"
    output_path = "${path.module}/lambda/kinesis_streams_response.zip"
}

resource "aws_lambda_function" "response_kinesis_streams" {
    filename = "${path.module}/lambda/kinesis_streams_response.zip"
    function_name = "kinesis_streams_response"
    role = aws_iam_role.response_role.arn

    handler = "kinesis_streams_response.lambda_handler"
    runtime = "python3.10"
}

resource "aws_iam_role_policy_attachment" "kinesis_streams_response_attachment" {
    role = aws_iam_role.response_role.name
    policy_arn = aws_iam_policy.kinesis_streams_generator_policy.arn
}

resource "aws_lambda_event_source_mapping" "kinesis_streams_response_mapping" {
    event_source_arn = aws_kinesis_stream.kinesis_stream_test.arn
    function_name = aws_lambda_function.response_kinesis_streams.arn
    starting_position = "LATEST"
}

# SNS

data "archive_file" "sns_response_zip" {
    type = "zip"
    source_file = "../Python Scripts/sns_response.py"
    output_path = "${path.module}/lambda/sns_response.zip"
}

resource "aws_lambda_function" "sns_response" {
    filename = "${path.module}/lambda/sns_response.zip"
    function_name = "sns_response"
    role = aws_iam_role.response_role.arn

    handler = "sns_response.lambda_handler"
    runtime = "python3.10"
}


resource "aws_lambda_permission" "sns_permission" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.sns_response.function_name
    principal = "sns.amazonaws.com"
    source_arn = aws_sns_topic.sns_test.arn
}

resource "aws_iam_role_policy_attachment" "sns_response_attachment" {
    role = aws_iam_role.response_role.name
    policy_arn = aws_iam_policy.sqs_response_policy.arn
}