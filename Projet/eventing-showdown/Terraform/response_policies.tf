resource "aws_iam_policy" "sqs_response_policy" {
    name = "sqs_response_policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = ["s3:putObject",]
            Resource = "${aws_s3_bucket.eventing_bucket.arn}/*"
        },
        {
            Effect = "Allow"
            Action = ["sqs:receiveMessage",
                "sqs:deleteMessage",
                "sqs:getQueueAttributes"
            ]
            Resource = aws_sqs_queue.sqs_test.arn
        }]
    })
}

