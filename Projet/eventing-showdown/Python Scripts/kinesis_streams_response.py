import boto3
import datetime
import base64

def lambda_handler(event,context):
    kinesis_stream_coded_record = event['Records'][0]['kinesis']['data']
    decoded_record = base64.b64(kinesis_stream_coded_record)

    s3 = boto3.resource('s3')
    
    bucket_name = "hexthelight-eventing-test-bucket"
    file_name = f"kinesis_streams/{datetime.datetime.now()}.json"

    s3.Bucket(bucket_name).put_object(Key=file_name, Body=str(decoded_record))

    return (
        {"statusCode": 200}
    )