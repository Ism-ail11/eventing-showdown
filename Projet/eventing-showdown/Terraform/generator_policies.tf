resource "aws_iam_policy" "sqs_generator_policy" {
    name = "sqs_generator_policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
                Effect = "Allow",
                Action = ["sqs:SendMessage",]
                Resource = aws_sqs_queue.sqs_test.arn
            },
            {
                Effect = "Allow",
                Action = ["ssm:GetParameter",]
                Resource = "arn:aws:ssm:eu-west-3:${var.account_id}:parameter/*"
            },
        ]
    })
}

resource "aws_iam_policy" "eventbridge_generator_policy" {
    name = "eventbridge_generator_policy"
    description = "policy for generator lambda to trigger eventbridge"
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
                Effect = "Allow",
                Action = ["events:PutEvents"]
                Resource = aws_cloudwatch_event_bus.eventbridge_test.arn
        }]
    })
}

resource "aws_iam_policy" "kinesis_streams_generator_policy" {
    name = "kinesis_streams_generator_policy"
    description = "policy for generator lambda to trigger kinesis"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow",
            Action = ["kinesis:PutRecord",
            "kinesis:GetRecords",
            "kinesis:GetShardIterator",
            "kinesis:DescribeStream",
            "kinesis:ListShards",
            "kinesis:ListStreams"]
            Resource = aws_kinesis_stream.kinesis_stream_test.arn
        }]
    })
}

resource "aws_iam_policy" "firehose_generator_policy" {
    name = "firehose_generator_policy"
    description = "policy for generator lambda to trigger firehose"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = ["firehose:PutRecord"]
            Resource = aws_kinesis_firehose_delivery_stream.kinesis_test.arn
        }]
    })

    tags = var.tags
}

resource "aws_iam_policy" "sns_generator_policy" {
    name = "sns_generator_policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = ["sns:Publish"]
            Resource = aws_sns_topic.sns_test.arn
        }]
    })
}