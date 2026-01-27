variable "service_name" {
  description = "Short name for the workload (used in naming AWS resources)."
  type        = string
}

variable "environment" {
  description = "Deployment environment (staging, prod, etc)."
  type        = string
}

variable "eks_cluster_arn" {
  description = "ARN of the EKS cluster hosting the workload. Used for deriving AWS account information."
  type        = string
}

variable "eks_oidc_issuer" {
  description = "OIDC issuer URL or host for the EKS cluster."
  type        = string
}

variable "kubernetes_namespace" {
  description = "Namespace of the Kubernetes service account that will assume the IAM role."
  type        = string
  default     = "default"
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account mapped to the IAM role. Defaults to service_name."
  type        = string
  default     = null
}

variable "s3_versioning_enabled" {
  description = "Enables versioning on the application S3 bucket."
  type        = bool
  default     = true
}

variable "s3_transition_to_ia_days" {
  description = "Number of days before moving objects to STANDARD_IA storage."
  type        = number
  default     = 90
}

variable "s3_expiration_days" {
  description = "Number of days before expiring objects from the S3 bucket."
  type        = number
  default     = 365
}

variable "s3_kms_key_arn" {
  description = "Optional KMS key ARN for S3 bucket encryption. Defaults to SSE-S3."
  type        = string
  default     = null
}

variable "sqs_visibility_timeout" {
  description = "Visibility timeout for the SQS queue in seconds."
  type        = number
  default     = 300
}

variable "sqs_message_retention_seconds" {
  description = "Message retention period for the SQS queue in seconds."
  type        = number
  default     = 604800
}

variable "sqs_dead_letter_max_receive" {
  description = "Number of receives before moving a message to the dead-letter queue."
  type        = number
  default     = 3
}

variable "log_retention_days" {
  description = "Number of days to retain application logs in CloudWatch."
  type        = number
  default     = 30
}

variable "log_group_kms_key_arn" {
  description = "Optional KMS key ARN for encrypting the CloudWatch log group."
  type        = string
  default     = null
}

variable "tags" {
  description = "Extra tags to merge into every created resource."
  type        = map(string)
  default     = {}
}
