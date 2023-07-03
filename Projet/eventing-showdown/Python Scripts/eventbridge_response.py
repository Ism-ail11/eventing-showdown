import boto3
import datetime

def lambda_handler(event, context):

    eventbridge_record = event['Detail']

    s3 = boto3.resource('s3')

    bucket_name = "hexthelight-eventing-test-bucket"


    file_name = f"eventbridge/{datetime.datetime.now()}.json"
    s3.Bucket(bucket_name).put_object(Key=file_name, Body=eventbridge_record)

    return (
        {"statusCode": 200}
    )