# ==========================================
# TERRAFORM CONFIGURATION
# Defines Terraform version and required providers
# ==========================================
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "sentinel-v3-state-1773670439"
    key            = "terraform/state/sentinel-v3.tfstate"
    region         = "us-west-1"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
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