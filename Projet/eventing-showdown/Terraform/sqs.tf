resource "aws_sqs_queue" "sqs_test" {
    name = "sqs_test"

    tags = var.tags
}

data "aws_iam_policy_document" "sqs_policy" {
    statement {
        sid = "sqs policy"
        effect = "Allow"

        principals {
            type = "*"
            identifiers = ["*"]
        }
        actions = ["sqs:SendMessage"]
        resources = [aws_sqs_queue.sqs_test.arn]
    }
}

resource "aws_sqs_queue_policy" "sqs_policy_attachment" {
    queue_url = aws_sqs_queue.sqs_test.id
    policy = data.aws_iam_policy_document.sqs_policy.json
}

resource "aws_ssm_parameter" "sqs_url_store" {
    name = "sqs_url"
    type = "String"
    value = aws_sqs_queue.sqs_test.url
}