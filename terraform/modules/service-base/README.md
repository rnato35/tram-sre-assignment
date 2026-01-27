# service-base module

Reusable Terraform module that provisions the AWS resources a Kubernetes workload typically needs:

- IAM Role for Service Accounts (IRSA) restricted to a single namespace/service account (S3, SQS, CloudWatch permissions).
- S3 bucket with versioning, lifecycle (90-day IA / 365-day expire), TLS-only policy, SSE-S3 or optional KMS encryption, and public access blocks.
- SQS queue with managed SSE, 7-day retention, 5 minute visibility timeout, and a dead-letter queue.
- CloudWatch log group with configurable retention and optional KMS encryption.

## Usage

```hcl
module "document_processor" {
  source = "./modules/service-base"

  service_name       = "document-processor"
  environment        = "staging"
  eks_cluster_arn    = "arn:aws:eks:us-east-1:825982271549:cluster/staging-cluster"
  eks_oidc_issuer    = "oidc.eks.us-east-1.amazonaws.com/id/EXAMPLE"
  kubernetes_namespace = "default"

  # Optional
  s3_versioning_enabled    = true
  s3_transition_to_ia_days = 90
  s3_expiration_days       = 365
  sqs_visibility_timeout   = 300
  log_retention_days       = 30

  tags = {
    Team = "platform"
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| `iam_role_arn` | IAM role used by the Kubernetes service account |
| `s3_bucket_name` | Name of the service S3 bucket |
| `s3_bucket_arn` | ARN for the service S3 bucket |
| `sqs_queue_url` | URL for the dedicated SQS queue |
| `sqs_queue_arn` | ARN for the service SQS queue |
| `sqs_dlq_url` | URL for the SQS dead-letter queue |
| `log_group_name` | Name of the log group used by the service |
