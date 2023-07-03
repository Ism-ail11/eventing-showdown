resource "aws_s3_bucket" "eventing_bucket" {
    bucket = "hexthelight-eventing-test-bucket"

    tags = var.tags
}