import boto3
import datetime

def lambda_handler(event, context):

    sns_record = event['Records']['Sns']['Message']

    s3 = boto3.resource('s3')

    bucket_name = "hexthelight-eventing-test-bucket"

    file_name = f"sqs/{datetime.datetime.now()}.json"
    s3.Bucket(bucket_name).put_object(Key=file_name, Body=sns_record)

    return (
        {"statusCode": 200}
    )