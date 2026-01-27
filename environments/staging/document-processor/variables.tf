variable "aws_region" {
  type        = string
  description = "AWS region to deploy supporting resources."
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the existing EKS cluster hosting the workload."
}

variable "service_name" {
  type        = string
  description = "Short name of the workload."
}

variable "environment" {
  type        = string
  description = "Deployment environment (staging, prod, etc.)."
}

variable "kubernetes_namespace" {
  type        = string
  description = "Namespace containing the Kubernetes service account."
  default     = "default"
}

variable "s3_versioning_enabled" {
  type        = bool
  description = "Enable versioning on the service S3 bucket."
  default     = true
}

variable "sqs_visibility_timeout" {
  type        = number
  description = "Visibility timeout for the service SQS queue."
  default     = 30
}

variable "log_retention_days" {
  type        = number
  description = "Days to retain service logs in CloudWatch."
  default     = 30
}

variable "log_group_kms_key_arn" {
  type        = string
  description = "KMS key ARN or alias used to encrypt the CloudWatch log group."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to propagate to created resources."
  default     = {}
}
