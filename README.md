# Sentinel - Multi-Cluster EKS Infrastructure

## Architecture Highlights
- **Dual VPC Strategy**: Separate networks for Gateway and Backend services.
- **Cross-VPC Connectivity**: Established via AWS VPC Peering.
- **Managed EKS**: Two Kubernetes clusters (v1.31) with managed node groups.
- **Automated Proxy Configuration**: Nginx Gateway automatically discovers the internal Backend NLB via CI/CD.

## Tech Stack
- **IaC**: Terraform 1.5+
- **Cloud**: AWS (EKS, VPC, IAM, NLB)
- **CI/CD**: GitHub Actions
- **Proxy**: Nginx

## Deployment Logic
The deployment is split into two phases:
1. **Provisioning**: Terraform builds the network and compute baseline.
2. **App Orchestration**: Kubernetes manifests are applied, and the Nginx proxy is dynamically configured with the internal backend DNS.