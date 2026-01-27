locals {
  normalized_service_name = lower(var.service_name)
  normalized_environment  = lower(var.environment)
  name_prefix             = "${local.normalized_environment}-${local.normalized_service_name}"

  bucket_name    = substr("${local.name_prefix}-data", 0, 63)
  queue_name     = substr("${local.name_prefix}-queue", 0, 80)
  queue_dlq_name = substr("${local.queue_name}-dlq", 0, 80)
  iam_role_name  = substr("${local.name_prefix}-irsa", 0, 64)

  service_account_name = lower(
    var.service_account_name != null && var.service_account_name != "" ? var.service_account_name : var.service_name
  )
  oidc_issuer_host    = replace(replace(var.eks_oidc_issuer, "https://", ""), "http://", "")
  eks_account_id      = element(split(":", var.eks_cluster_arn), 4)
  oidc_provider_arn   = "arn:aws:iam::${local.eks_account_id}:oidc-provider/${local.oidc_issuer_host}"
  service_account_sub = "system:serviceaccount:${var.kubernetes_namespace}:${local.service_account_name}"

  s3_object_prefix = "services/${var.kubernetes_namespace}/${local.service_account_name}/*"

  base_tags = {
    Environment = var.environment
    Service     = var.service_name
  }

  tags = merge(local.base_tags, var.tags)
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/${local.normalized_environment}/${local.normalized_service_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.log_group_kms_key_arn

  tags = local.tags
}
