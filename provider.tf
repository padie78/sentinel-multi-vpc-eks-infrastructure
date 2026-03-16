# ==========================================
# TERRAFORM CONFIGURATION
# Defines Terraform version and required providers
# ==========================================
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "sentinel-v3-state-1773670439" # Reemplaza con el nombre real del bucket del cliente
    key            = "terraform/state/sentinel-v3.tfstate" # Ruta donde se guardará el archivo dentro del bucket
    region         = "us-west-1"
    encrypt        = true
  }

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
  profile = "cliente"

  # Global tagging: Automatically applies tags to all supported resources
  default_tags {
    tags = var.tags
  }
}