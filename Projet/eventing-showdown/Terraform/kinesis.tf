resource "aws_kinesis_stream" "kinesis_stream_test" {
    name = "kinesis_stream_test"
    shard_count = 1
    retention_period = 24
    
    tags = var.tags
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis_test" {
    name = "kinesis_firehose_test"
    destination = "extended_s3"

    extended_s3_configuration {
        role_arn = aws_iam_role.firehose_role.arn
        bucket_arn = aws_s3_bucket.eventing_bucket.arn
        prefix = "firehose/"

        processing_configuration {
          enabled = "true"

          processors {
            type = "Lambda"

            parameters { 
                parameter_name = "LambdaArn"
                parameter_value = aws_lambda_function.firehose.arn
            }
          }
        }
    }
}

# role access

resource "aws_iam_role" "firehose_role" {
    name = "firehose_to_s3"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
            Effect = "Allow"
            Action = "sts:AssumeRole"
            Principal = {
                Service = "firehose.amazonaws.com"
            }
    }
    })
}

resource "aws_iam_policy" "firehose_lambda" {
    name = "firehose_lambda_trigger"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = ["Lambda:InvokeFunction"],
                Effect = "Allow"
                Resource = aws_lambda_function.firehose.arn
            },
            {
                Action = ["s3:putObject"]
                Effect = "Allow"
                Resource = "${aws_s3_bucket.eventing_bucket.arn}/*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "firehose_trigger_attachment" {
    role = aws_iam_role.firehose_role.name
    policy_arn = aws_iam_policy.firehose_lambda.arn
}

# configure lambda processor

data "archive_file" "firehose_zip" {
    source_file = "../Python Scripts/firehose_response.py"
    output_path = "${path.module}/lambda/firehose_response.zip"
    type = "zip"
}

resource "aws_lambda_function" "firehose" {
    function_name = "FirehoseProcessor"
    filename = "${path.module}/lambda/firehose_response.zip"
    role = aws_iam_role.generator_role.arn
    
    handler = "firehose_response.lambda_handler"
    runtime = "python3.10"
    timeout = 60

    tags = var.tags
}