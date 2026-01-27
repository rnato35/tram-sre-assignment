output "iam_role_arn" {
  description = "ARN of the IAM role that can be assumed by the Kubernetes service account."
  value       = aws_iam_role.irsa.arn
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket provisioned for the service."
  value       = aws_s3_bucket.this.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket provisioned for the service."
  value       = aws_s3_bucket.this.arn
}

output "sqs_queue_url" {
  description = "URL of the SQS queue created for the service."
  value       = aws_sqs_queue.this.id
}

output "sqs_queue_arn" {
  description = "ARN of the SQS queue created for the service."
  value       = aws_sqs_queue.this.arn
}

output "sqs_dlq_url" {
  description = "URL of the SQS dead-letter queue."
  value       = aws_sqs_queue.dlq.id
}

output "log_group_name" {
  description = "Name of the CloudWatch log group managed for the service."
  value       = aws_cloudwatch_log_group.this.name
}
