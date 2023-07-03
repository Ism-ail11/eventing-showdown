import boto3
import datetime

def lambda_handler(event, context):

    sqs_record = event['Records']

    s3 = boto3.resource('s3')

    bucket_name = "hexthelight-eventing-test-bucket"

    for i in sqs_record:
        body = i['body']
        file_name = f"sqs/{datetime.datetime.now()}.json"
        s3.Bucket(bucket_name).put_object(Key=file_name, Body=body)

    return (
        {"statusCode": 200}
    )