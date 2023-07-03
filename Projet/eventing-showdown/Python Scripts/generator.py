import boto3
import datetime
import random
import json
import urllib3

def lambda_handler(event,context):

# Basic Details

    api_url = 'https://api.api-ninjas.com/v1/facts?limit=1'

    http = urllib3.PoolManager()

    rand_fact = http.request("GET",api_url, headers={'X-Api-Key': 'HBvu0lQ+JAitmHen/FAe5Q==MMLeP8qd4OBfvR79'})    

    message = {
        "time": str(datetime.datetime.now()),
        "id": random.randint(1,1000),
        "service": "test",
        "randomFact": str(rand_fact)
    }

# SQS

    def sqs_trigger(payload):
        ssm = boto3.client('ssm')
        sqs_url = ssm.get_parameter(
            Name="sqs_url"
        )

        sqs = boto3.client('sqs')
        
        sqs.send_message(
            QueueUrl = sqs_url['Parameter']['Value'],
            MessageBody = json.dumps(payload)
        )

# Eventbridge

    def eventbridge_trigger(payload):
        eventbridge = boto3.client('events')
        
        eventbridge.put_events(
            Entries = [{
                "Time": datetime.datetime.now(),
                "Source": "test.lambda",
                "DetailType": "Me Lambda Payload",
                "Detail": json.dumps(payload),
                "EventBusName": "eventbridge_test"
            },]
        )

# Kinesis

    def kinesis_data_streams_trigger(payload):
        kinesis_data_streams = boto3.client('kinesis')

        kinesis_data_streams.put_record(
            StreamName = "kinesis_stream_test",
            Data = json.dumps(payload),
            PartitionKey = '1234'
        )

# Firehose

    def kinesis_firehose_trigger(payload):
        kinesis_firehose = boto3.client('firehose')

        kinesis_firehose.put_record(
            DeliveryStreamName = 'kinesis_firehose_test',
            Record = {
                'Data': json.dumps(payload)
            }
        )

# SNS

    def sns_trigger(payload):
        ssm = boto3.client('ssm')
        sns_url = ssm.get_parameter(
            Name="sns_arn"
        )

        sns = boto3.resource('sns')

        topic = sns.arn(sns_url)

        topic.publish(
            TopicArn = sns_url,
            Message = str(payload)
        )

# Pattern to trigger

    sns_trigger(message)

    return (
        print(message)
    )