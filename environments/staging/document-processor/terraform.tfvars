aws_region           = "us-east-1"
eks_cluster_name     = "tram-case-assignment-cluster"
service_name         = "document-processor"
environment          = "staging"
kubernetes_namespace = "default"

tags = {
  Team = "platform"
}
