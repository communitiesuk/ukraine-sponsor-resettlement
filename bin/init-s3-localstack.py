import boto3

s3_client = boto3.client(
    "s3",
    endpoint_url=f"http://127.0.0.1:4566",
    aws_access_key_id="test",
    aws_secret_access_key="test"
)

s3_client.create_bucket(Bucket="test-bucket")
