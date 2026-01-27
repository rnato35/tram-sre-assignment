# tram-sre-assignment

## Overview

This repo provisions the AWS foundation (S3, SQS, CloudWatch, IAM IRSA role) via Terraform, defines the Kubernetes deployment stack for the `document-processor` workload with kustomize overlays, and wires everything into a GitOps workflow through ArgoCD Applications. The goal is to codify infra + app resources once and promote changes from staging to production predictably.

## Prerequisites

- Terraform >= 1.14.3 with AWS provider 6.x
- kubectl >= 1.27 with access to your EKS cluster
- kustomize (if not using `kubectl kustomize`)
- ArgoCD >= 2.6 installed in your cluster for GitOps deployment

## Setup Instructions

### Terraform (service base resources)
```bash
cd environments/staging/document-processor
terraform init
terraform validate
terraform plan --var-file=terraform.tfvars
# terraform apply--var-file=terraform.tfvars when ready
```

### Kubernetes manifests
```bash
# Render and dry-run apply
kubectl apply --dry-run=client -k kubernetes/overlays/staging
kubectl apply --dry-run=client -k kubernetes/overlays/production
# (install Prometheus Operator CRDs first or pass --validate=false to avoid CRD warnings)
```

### ArgoCD applications
```bash
kubectl apply -n argocd -f argocd/document-processor.yaml
```

## Architecture Decisions

- **Terraform module** consolidates IRSA role, S3/SQS/CloudWatch resources with strict least-privilege policies. Inputs allow pointing at any EKS cluster and customizing encryption, lifecycle, and messaging behavior.
- **Kustomize** splits base manifests from environment overlays to avoid duplication while letting staging/production override replicas, resources, ConfigMap values, and feature flags.
- **GitOps via ArgoCD** uses two Applications with sync-waves and automated sync. Staging tracks `main`; production tracks a mutable `prod` tag. This enforces “staging first, prod after promotion” without manual edits.
- **Security posture**: pods run as non-root with read-only filesystems, IRSA ties tasks to IAM roles, S3/SQS enforce encryption and access controls, and CloudWatch logs have configurable retention.

## Environment Promotion Strategy

1. **Deploy to staging first** – ArgoCD syncs the `document-processor-staging` application (sync-wave `0`) against `kubernetes/overlays/staging`, tracking the `main` branch. Automated sync, pruning, and self-heal keep staging always up to date with the latest commit for validation (tests, smoke checks, etc.).
2. **Promote to production** – After staging is validated, retag the desired commit to `prod` (e.g., `git tag -f prod <sha> && git push origin --force prod`). ArgoCD watches `refs/tags/prod`, so when the tag moves it reconciles the `document-processor-production` application (sync-wave `1`) against `kubernetes/overlays/production`. This ensures production only deploys commits that explicitly passed staging.
3. **Handle rollbacks** – To roll back, move the `prod` tag to the last known-good commit (`git tag -f prod <good-sha>; git push --force origin prod`) or revert the offending commit and retag. ArgoCD notices the tag change and self-heals production to match. Staging continues to track `main`, so you reproduce/verify the fix there first before updating the `prod` tag again. In emergencies you can temporarily disable automated sync on production, force-sync to a stable revision, then re-enable automation once the rollback is complete.

## What I'd Improve Next

- Automated testing pipeline – Add a lightweight CI step (GitHub Actions) that runs terraform fmt/validate, terraform plan, and kubectl kustomize smoke tests before changes merge. That codifies the manual commands you’re running now.
- Secret management integration – Drop in ExternalSecrets/AWS Secrets Manager integration so the document-processor-secrets reference is actually fed from AWS and kept out of Git.
- Analyze runtime metrics (CPU/memory, queue depth trends) to tune resource requests/limits and autoscaling rules based on real consumption rather than conservative estimates.
- Tailor deployment strategies (blue/green, canary via Argo Rollouts, etc.) to the service’s criticality: e.g., gradually expose production traffic for user-facing components, use instant rollbacks for high-severity systems, and choose rollout windows that reflect how quickly the business needs recovery if issues arise.
- Split README sections into individual docs (e.g., docs/terraform.md, docs/k8s.md) with diagrams and runbooks so the root README stays concise.

## Time Spent

- Terraform module: ~2.5 hours
- Kubernetes manifests & kustomize: ~1 hour
- ArgoCD / GitOps wiring + documentation: ~1.5 hour
