module "service_base" {
  source = "../../../terraform/modules/service-base"

  service_name         = var.service_name
  environment          = var.environment
  eks_cluster_arn      = data.aws_eks_cluster.this.arn
  eks_oidc_issuer      = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  kubernetes_namespace = var.kubernetes_namespace

  s3_versioning_enabled  = var.s3_versioning_enabled
  sqs_visibility_timeout = var.sqs_visibility_timeout
  log_retention_days     = var.log_retention_days
  log_group_kms_key_arn  = var.log_group_kms_key_arn

  tags = local.tags
}
