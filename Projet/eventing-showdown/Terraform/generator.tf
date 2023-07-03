data "archive_file" "zip_generator"{
    type = "zip"
    source_file =  "../Python Scripts/generator.py"
    output_path = "${path.module}/lambda/generator.zip"
}

resource "aws_lambda_function" "generator" {
    filename = "${path.module}/lambda/generator.zip"
    function_name = "event_generator"
    role = aws_iam_role.generator_role.arn

    handler = "generator.lambda_handler"
    runtime = "python3.10"

    tags = var.tags
}

# Lambda permission configuration

resource "aws_iam_role" "generator_role" {
    name = "generator_role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
            Effect = "Allow",
            Action = "sts:AssumeRole"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
    }
    })

    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "generator_policy_attachment_sqs" {
    role = aws_iam_role.generator_role.name
    policy_arn = aws_iam_policy.sqs_generator_policy.arn
}

resource "aws_iam_role_policy_attachment" "generator_policy_attachment_eventbridge" {
    role = aws_iam_role.generator_role.name
    policy_arn = aws_iam_policy.eventbridge_generator_policy.arn
}

resource "aws_iam_role_policy_attachment" "generator_policy_attachment_kinesis_streams" {
    role = aws_iam_role.generator_role.name
    policy_arn = aws_iam_policy.kinesis_streams_generator_policy.arn
}

resource "aws_iam_role_policy_attachment" "generator_policy_attachment_firehose" {
    role = aws_iam_role.generator_role.name
    policy_arn = aws_iam_policy.firehose_generator_policy.arn
}

resource "aws_iam_role_policy_attachment" "generator_policy_attachment_sns" {
    role = aws_iam_role.generator_role.name
    policy_arn = aws_iam_policy.sns_generator_policy.arn
}

# State function configuration

# resource "aws_sfn_state_machine" "generator_supercharger" {
#     name = "generator_supercharger"

#     tags = var.tags
# }