import json
import boto3

def lambda_handler(event, context):
    # TODO implement
    client=boto3.client('ec2')
    response=client.describe_instances()
    for data in response['Reservations']:
        for ec2_val in data['Instances']:
            instance_id=(ec2_val['InstanceId'])
            status=(ec2_val['State']['Name'])
        if status=="running":
        # TODO: write code...
            raise Exception(f"Instance {instance_id} is running.")
    return {
        'statusCode': 200,
        'body': json.dumps("success")
        }