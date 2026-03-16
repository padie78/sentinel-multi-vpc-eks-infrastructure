# ==========================================
# TERRAFORM CONFIGURATION
# Defines Terraform version and required providers
# ==========================================
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Añadimos el provider de Kubernetes
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

# ==========================================
# AWS PROVIDER
# Configures AWS access using variables from .tfvars
# ==========================================
provider "aws" {
  region = var.aws_region

  # Global tagging: Automatically applies tags to all supported resources
  default_tags {
    tags = var.tags
  }
}

# ==========================================
# KUBERNETES PROVIDER
# Permite a Terraform interactuar con el cluster EKS
# ==========================================
provider "kubernetes" {
  # IMPORTANTE: Estos datos vienen de los outputs de tu módulo EKS
  # Si tu módulo EKS está en un for_each, deberás ajustar la referencia
  host                   = module.eks["gateway"].cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks["gateway"].cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # Esto usa tu usuario 'agents_ai' para obtener el token de acceso
    args = ["eks", "get-token", "--cluster-name", module.eks["gateway"].cluster_name]
  }
}