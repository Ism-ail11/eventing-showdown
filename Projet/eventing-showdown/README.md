# Eventing and Messaging Showdown
![Eventing Architecture](./04%20-%20Eventing%20and%20Messaging%20Showdown%20-%20Page%201.png)
## Project Overview
The purpose of this project is to explore and create the various event streams and messaging queues offered by AWS to simulate a real life event-based architecture, having an input Lambda function publish to the various technologies, which then features data manipulation either by another lambda function or by Data Firehose, and the results then stored in an S3 bucket.
### Project Outcome
By the end of this project is to gain a basic understanding of how various eventing and messaging technologies work in AWS and understand the various use cases for each.
### Project Outputs
- Terraform Scripts which contains all AWS resources provisioned
- Python script for all relevant lambda functions
- Notes on each service including what to use and when
### Out of Scope
- Configuring dead letter queues
- Apache Self hosted Kafka
- Kinesis Video Streams

## Project Details
How you configure and choose your eventing and messaging technologies is vital to ensuring you can build a robust, decoupled architecture and, with event-based architecture taking center stage in modern cloud frameworks, being able to understand the various options available and choose accordingly could mean the difference between having an amazing, scalable, cost effective architecture and an admin nightmare.

So in order to learn the nuances between the various technologies available by AWS, I will be comparing Kinesis Data Streams, Kinesis Data Firehose, SQS, SNS and Eventbridge across a basic scenario which involves a Lambda function that generates a simple JSON object which then subsequently triggers the different technologies which each route the request to a response Lambda function that parses the event / message payload and store the results in an S3 bucket.

### Pricing
This project cost $0.05 as most items fell under the free tier due to my low usage requirements.

## Learning from the Project

### Composition of Generator function
The generator function is designed to return a simple json object with the following:
```json
{
	"time": datetime,
	"id": randint(1,1000),
	"service": "eventbridge" | "sqs" | "data stream" | "data firehose",
	"random fact": factoid
}
```

I'm using the facts api from API Ninjas to add a random fact just to add an extra element to the JSON.

There is a separate function for each route which I am then calling within the main `lambda_handler` function just to keep the code as clean as possible.

### Using SSM
One of the interesting challenges in creating my generator function I found was referencing the endpoint for the SQS queue when that value would not be apparent until the TF files had been applied and created.

A neat solution that I found for this was to store the SQS queue as a value within the SSM Parameter Store, and then within my Lambda function, call SSM to retrieve the url. 

This does present an interesting architectural challenge in that that extra call to SSM will increase latency slightly and adds an extra dependency to the function to work, so this may not be the best idea in a production environment but is fine for this use case. An alternative would be to use either the `list_queues` or `get_queue_url` function to call SQS directly and retrieve the URL that way. I chose to use SSM for this instance to gain experience and understand where SSM Parameter Store could be utilised.
### Batching Events and Messages
Many of the services that I tested included the ability to batch messages in order to make effective use of function invocations. Whilst this was not something that I tested in this project it's useful to see how, for AWS estates that make heavy use of Lambda that it's a great way of being able to cut costs (just batching the messages so that each Lambda function processes 2 messages will effectively halve your costs...).

There is a fine balance to be struck when looking at reducing cost by batching as having a lambda function polling for too long could cause a performance bottleneck further down the chain. This can be measured as a KPI and potentially build in some kind of automation so that the amount of messages that Lambda processes per invocation increases with demand.

### Kinesis Firehose
Kinesis Data Firehose was an interesting one to learn about because from all of the marketing material it is described as an ETL service for streaming data however I did not appreciate that it uses Lambda as part of the transformation layer which requires setting up all the necessary permissions and resources.

The built-in blueprint however is really useful and I used that pretty much untouched for my data transformations, this is something I want to cover later to understand how far you can go with these transformation.

### How to configure an Event Backbone in AWS
When I first learned of event-based architectures and event backbones my first assumption was that this was a methodology that would have been serviced by Kinesis, by its ability to stream data at massive scale, this was driven by my inexperience with Kinesis Data Shards which I believed were routing tunnels, rather than an ability to provide more throughput.

In the course of my research, I realised how powerful EventBridge is at routing events and messages which can then feed SQS topics, Lambda functions, even Kinesis streams. I originally didn't give EventBridge much credit as my only usage of it in the past was to trigger state changes in ECS based on cron jobs. EventBridge is definitely a service that I want to pay a closer attention to in the future as it has a lot of potential.
