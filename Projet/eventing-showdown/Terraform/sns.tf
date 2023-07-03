resource "aws_sns_topic" "sns_test" {
    name = "sns-test-topic"
}

resource "aws_sns_topic_subscription" "sns_sub" {
    topic_arn = aws_sns_topic.sns_test.arn
    protocol = "lambda"
    endpoint = aws_lambda_function.sns_response.arn
}

resource "aws_ssm_parameter" "sns_arn" {
    name = "sns_arn"
    type = "String"
    value = aws_sns_topic.sns_test.arn
}

data "aws_iam_policy_document" "sns_policy" {
    statement {
        sid = "sns policy"
        effect = "Allow"

        principals {
            type = "*"
            identifiers = ["*"]
        }
        actions = ["SNS:Subscribe",
        "SNS:SetTopicAttributes",
        "SNS:RemovePermission",
        "SNS:Receive",
        "SNS:Publish",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:AddPermission",
        ]
        resources = [aws_sns_topic.sns_test.arn]
    }
}

resource "aws_sns_topic_policy" "sns_policy_attachment" {
    arn = aws_sns_topic.sns_test.arn
    policy = data.aws_iam_policy_document.sns_policy.json
}