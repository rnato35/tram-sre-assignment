output "iam_role_arn" {
  description = "IAM role assumed by the Kubernetes service account."
  value       = module.service_base.iam_role_arn
}

output "s3_bucket_name" {
  description = "S3 bucket created for the service."
  value       = module.service_base.s3_bucket_name
}

output "sqs_queue_url" {
  description = "SQS queue URL allocated to the service."
  value       = module.service_base.sqs_queue_url
}

output "sqs_dlq_url" {
  description = "SQS dead-letter queue URL."
  value       = module.service_base.sqs_dlq_url
}

output "log_group_name" {
  description = "CloudWatch log group storing service logs."
  value       = module.service_base.log_group_name
}
