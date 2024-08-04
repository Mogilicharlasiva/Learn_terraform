import boto3
import json

client=boto3.client('ec2')

response=client.describe_instances()
print(response)
