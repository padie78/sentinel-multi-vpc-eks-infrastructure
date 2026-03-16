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